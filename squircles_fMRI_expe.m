function [data,timing,getout]=squircles_fMRI_expe(participant,blocks,startblock)
% [data,timing,getout]=squircles_fMRI_expe(participant,blocks,startblock)
% use squircles_fMRI_runner to create participant, blocks


scanning = 0;
training = 0;
debug = 0;
fdb.aud=1;
fdb.txt=0;
tic
rand('state',sum(100*clock)); % init rand seed

%% timing parameters
stimdur=1.5;
if debug
    stimdur=0.5;
end
if scanning
    waitdurmin = 2;
    waitdurmax = 6;
    waitdurmean = 4;
else
    waitdurmin  = 0.5;
    waitdurmax  = 1.5;
    waitdurmean = 1;
end

%% response buttons
resptriggers=[7 71 167 231];


%% stimuli graphical parameters
nstims=8;
% positions of the stimuli on the screen
theta=linspace(0,360,nstims+1); 
theta=theta(1:end-1);
x=sin(theta*pi/180);
y=cos(theta*pi/180);
radi=100;
% fixation size
tiny=5;
% luminances
whitecol = RGBcor(1,1);
lumiBG = .2; % background luminance
bgcol = RGBcor(1,lumiBG);
lumiIM = .09; % luminance of each item




%% open psychtoolbox %
try
    [w, rect] = Screen('OpenWindow', 0, 0,[],32,2);
    HideCursor;	% Hide the mouse cursor
    Screen('TextFont', w, 'Helvetica');
    Screen('TextSize', w , 16 );
    center=[rect(3)/2 rect(4)/2]; % screen center
    tinyrect=[center-tiny, center+tiny]; % fixation rect
    KbName('UnifyKeyNames')
    
    data=[];
    timing=[];
    for icurrentblock=startblock:length(blocks)
        
        %% load variables from the block structure
        for varload = blocks(icurrentblock).variables
            eval(['clear ' varload{1}])
            eval([varload{1} '= blocks(icurrentblock).' varload{1} ';']);
        end
        ntrials = 5 %%%%%% DELETE THIS LINE
        
        %% jittered waiting time after trial
        if scanning
            waitdur = waitdurmin  + rand(1,ntrials)*(waitdurmax-waitdurmin);
            waitdur = waitdurmean + (waitdur-mean(waitdur));
        else
            waitdur = 0.5*ones(1,ntrials);
        end
        
        %% INSTRUCTIONS SCREEN
         linesize=24;
        Screen(w,'FillRect',bgcol);
        if icurrentblock>1
            Screen(w,'DrawText',sprintf('Great! You have completed %i blocks out of 6!',icurrentblock-1),(rect(3)/2)-200, (rect(4)/2)-200);
        end
        Screen(w,'DrawText',['On the next blocks: ' task ' !'],(rect(3)/2)-200,rect(4)/2 -250,whitecol);
        if strcmp(task,'color')
            Screen(w,'DrawText',['Say whether on average it is more red or more blue.'],(rect(3)/2)-200, (rect(4)/2)+50,whitecol);
            if SR==1
                Screen(w,'DrawText',['Simply click left for BLUE and right for RED!'],(rect(3)/2)-200, (rect(4)/2)+100,whitecol);
            elseif SR==2
                Screen(w,'DrawText',['Simply click left for RED and right for BLUE!'],(rect(3)/2)-200, (rect(4)/2)+100,whitecol);
            end
         xcoords = ((1:11) - 6)*50 +  rect(3)/2;        
        for k=1:11
            if SR==1
                c=(k-1)/10;
            else
                c=(11-k)/10;
            end
            Hc= [c 0 1-c]; % BLUE -> RED color
            Screen(w,'FillRect',RGBcor(Hc,lumiIM),[(xcoords(k)-20) 290 (xcoords(k)+20) 330]);
        end
        
        else
            Screen(w,'DrawText',['Say whether on average it is more circlar or more square.'],(rect(3)/2)-200,(rect(4)/2),+50,whitecol);
            if SR==1
                Screen(w,'DrawText',['Simply click left for SQUARE and right for CIRCLE !'],(rect(3)/2)-200,(rect(4)/2)+100,whitecol);
            elseif SR==2
                Screen(w,'DrawText',['Simply click left for CIRCLE and right for SQUARE !'],(rect(3)/2)-200,(rect(4)/2)+100,whitecol);
            end
    xcoords = ((1:11) - 6)*50 +  rect(3)/2;        
               for k=1:11
            if SR==1
                s=1+(k-1)/10;
            else
                s=1+(11-k)/10;
            end
            Ht=0:(2*pi/180):(2*pi); % shapes are defined by parametric curves of Ht (angle)
            Hr = 45*pi/180; % the rotation of the hyperellipse
            Ha=sqrt(abs(1500./4.*gamma(1.+2./s)./(gamma(1.+1./s)).^2)); % define the parameter a from the expected area + curvature S(n)
            Hx=abs(cos(Ht)).^(2./s).*Ha.*sign(cos(Ht)) ; % x coordinates
            Hy=abs(sin(Ht)).^(2./s).*Ha.*sign(sin(Ht)) ; % y coordinates
            Hc= [0.5 0 0.5]; % color
            Hpoly = [Hx*cos(Hr)-Hy*sin(Hr) + xcoords(k);...
                Hx*sin(Hr)+Hy*cos(Hr) + 310]';
            Screen('FillPoly', w, RGBcor(Hc,lumiIM), Hpoly, 1);           
        end  
            
        end
        Screen(w,'DrawText',['You will hear two tones rising when correct, falling when incorrect.'],(rect(3)/2)-200,(rect(4)/2)+150,whitecol);
        Screen(w,'DrawText',sprintf('Experimenter: press S to start'),30,20);
        Screen(w,'Flip');
        
        %% wait key press to start
        press=0;
        while press==0;
            [tmpx tmpy buttons]=KbCheck;
            if buttons(KbName('S'))
                press=1;
            end
        end
        Screen(w,'FillRect',bgcol);
        Screen(w,'Flip');
        WaitSecs(0.5);
        
        % WAIT FOR TRIGGER SCREEN
        Screen(w,'FillRect',bgcol);
        trainingstr={'Training',sprintf('Block %i',icurrentblock)};
        scanningstr={'ON','OFF'};
        Screen(w,'DrawText',sprintf('%s -- scanning is %s.',trainingstr{2-training},scanningstr{2-scanning}),200,40,255);
        if scanning & ~training
            Screen(w,'DrawText',sprintf('Waiting for scan trigger or (T) to start.'),200,80,255);
        else
            Screen(w,'DrawText',sprintf('Waiting for (T) to start.'),200,80,255);
        end
        Screen(w,'Flip');
        press=0;
        while 1
            if scanning
                value=-1;
                value=lptread(889);
                if value==199;
                    break;
                end
            end
            [kdown secs keycodes]=KbCheck;
            % check escape key
            if kdown==1
                if keycodes(KbName('escape'))==1;
                    getout=1;
                    break;
                end
                if keycodes(KbName('T'))==1;
                    break;
                end
            end
        end
        startexp = GetSecs;
        
        
        %% LEAD IN
        if scanning
            Screen(w,'FillRect',bgcol);
            Screen(w,'Flip');
            Screen('FillOval', w, [0.2 0.2 0.2], smallfixpoint);
            WaitSecs(10);
        end
        %% here we go
        getout=0;
        
        for t=1:ntrials;
            if getout==1
                break
            end
            
            %% stimulus
            % actual values for color and shape
            S = SS(t,:);
            C = CC(t,:);
            % graphical construction
            % hyperellipses ! see http://en.wikipedia.org/wiki/Superellipse
            Harea=2500; % area is kept constant for all shapes
            Ht=0:(2*pi/180):(2*pi); % shapes are defined by parametric curves of Ht (angle)
            Hr = 45*pi/180; % the rotation of the hyperellipse
            for n=1:nstims
                Ha=sqrt(abs(Harea./4.*gamma(1.+2./S(n))./(gamma(1.+1./S(n))).^2)); % define the parameter a from the expected area + curvature S(n)
                Hx=abs(cos(Ht)).^(2./S(n)).*Ha.*sign(cos(Ht)) ; % x coordinates
                Hy=abs(sin(Ht)).^(2./S(n)).*Ha.*sign(sin(Ht)) ; % y coordinates
                Hc= [C(n) 0 1-C(n)]; % color
                Hpoly = [Hx*cos(Hr)-Hy*sin(Hr) + center(1)+radi*x(n);...
                    Hx*sin(Hr)+Hy*cos(Hr) + center(2)+radi*y(n)]';
                Screen('FillPoly', w, RGBcor(Hc,lumiIM), Hpoly, 1);
            end
            Screen(w,'FillOval',whitecol,tinyrect); % fixation
            
            %% present stimulus and get response
            [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen(w,'Flip');
            trialstart=GetSecs; % timing starts for collecting response
            respcode=[];RT=[];press=0;
            while GetSecs<trialstart + stimdur; % response window
                % check keyboard
                [kdown secs keycodes]=KbCheck;
                if any(keycodes);
                    press=press+1;
                    if keycodes(KbName('escape'))==1;
                        getout=1;
                        break
                    end
                    if keycodes(KbName('S'))==1
                        respcode=1;
                    end
                    if keycodes(KbName('L'))==1
                        respcode=3;
                    end
                end
                
                %                 % check mouse
                %                 if ~scanning
                %                 [tmpx tmpy buttons]=GetMouse;
                %                 if any(buttons)
                %                     press=press+1;
                %                     respcode=find(buttons,1);
                %                 end
                %                 end
                
                % check parallel port
                if scanning
                    value=-1;
                    value=lptread(889);
                    if any(value==resptriggers)
                        press=press+1;
                        respcode=1+(find(value==resptriggers,1)>2)*2;
                    end
                end
                
                % record RT if press
                if press==1;
                    RT=GetSecs-trialstart;
                end
            end
            disp(['trial', num2str(t), ' -- key ',num2str(respcode),', ',num2str(RT),' ms']);
            Screen(w,'FillRect',bgcol);
            Screen(w,'FillOval',whitecol,tinyrect);
            Screen(w,'Flip');
            
            %% accuracy and feedback
            % accuracy
            if isempty(respcode);
                respcode=0;
                cor=0;
                RT=0;
            else
                cor = respcode == corkey(t);
                %                 if strcmp(task,'colour');
                %                     cor = (mc(t)>2 && respcode==keyright) || (mc(t)<3 && respcode==keyleft);
                %                 elseif strcmp(task,'shape');
                %                     cor = (ms(t)>2 && respcode==keyright) || (ms(t)<3 && respcode==keyleft);
                %                 end
            end
            
            % auditory feedback
            if fdb.aud
                if cor==1
                     note2([600 1200],[0.2 0.2]);
                else
                     note2([1200 600],[0.2 0.2]);
                end
            end
            % visual feedback
            if fdb.txt
                if cor==1
                    Screen(w,'DrawText','YES',center(1),center(2));
                else
                    Screen(w,'DrawText','NO',center(1),center(2));
                end
                Screen(w,'Flip');
            end
            
            %% log data
            blockdata.sub(t)=participant.number;
            blockdata.sess(t)=participant.session;
            blockdata.ms(t)=ms(t);
            blockdata.mc(t)=mc(t);
            blockdata.vs(t)=vs(t);
            blockdata.vc(t)=vc(t);
            blockdata.task=task;
            blockdata.tasknum(t)=strcmp(task,'shape');
            blockdata.nstims(t)=nstims;
            blockdata.S(:,t)=S;  % actual colour and shape values
            blockdata.C(:,t)=C;
            blockdata.Smu(t)= ceil(abs(blockdata.ms(t)-2.5));
            blockdata.Cmu(t)= ceil(abs(blockdata.mc(t)-2.5));
            blockdata.Scat(t)= 2*(blockdata.ms(t)>2)-1; % -1=categ1 (square), 1=categ2 (circle)
            blockdata.Ccat(t)= 2*(blockdata.mc(t)>2)-1; % -1=categ1 (blue),   1=categ2 (red)
            blockdata.SR(t)=SR;
            blockdata.respcat(t)= (respcode-2).*(respcode~=0).*sign(SR-0.5); % resp = -1 (categ1) or 1 (categ2) or 0 (none)
            blockdata.stimcat(t)= blockdata.Scat(t).*(blockdata.tasknum(t)==1) + blockdata.Ccat(t).*(blockdata.tasknum(t)==0);
            blockdata.RT(t)=RT;
            blockdata.respcode(t)=respcode;
            blockdata.cor(t)=cor;
            blockdata.err(t)=1-cor;
            blockdata.corkey(t)=corkey(t);
            blockdata.mu(t)     = blockdata.Smu(t) .*(blockdata.tasknum(t)==1) + blockdata.Cmu(t) .*(blockdata.tasknum(t)==0);
            blockdata.irrmu(t)  = blockdata.Cmu(t) .*(blockdata.tasknum(t)==1) + blockdata.Smu(t) .*(blockdata.tasknum(t)==0);
            blockdata.sig(t)    = blockdata.vc(t)  .*(blockdata.tasknum(t)==1) + blockdata.vs(t)  .*(blockdata.tasknum(t)==0);
            blockdata.irrsig(t) = blockdata.vs(t)  .*(blockdata.tasknum(t)==1) + blockdata.vc(t)  .*(blockdata.tasknum(t)==0);
            
            blocktiming.day = datestr(clock);
            blocktiming.startexp = startexp;
            blocktiming.trialstart(t) = trialstart;
            blocktiming.VBLTimestamp(t)= VBLTimestamp-startexp;
            blocktiming.StimulusOnsetTime(t)= StimulusOnsetTime-startexp;
            blocktiming.FlipTimestamp(t)= FlipTimestamp-startexp;
            blocktiming.Missed(t)= Missed;
            blocktiming.Beampos(t)= Beampos;
            
            %% jitterized ISI
            waitadjust = (GetSecs-trialstart) - (stimdur);
            blocktiming.waitadjust(t) = waitadjust;
            if waitadjust<waitdur(t)
                WaitSecs( waitdur(t) - waitadjust );
            else
                WaitSecs( waitdur(t) );
            end
            
            save(participant.filename,'blockdata','blocktiming','-append')
        end % end trial loop
        
        data = cat(2,data,blockdata);
        timing = cat(2,timing,blocktiming);
        save(participant.filename,'data','timing','-append')
        if scanning
            WaitSecs(10)
        end
        
    end % end block loop

catch error
    save datatmp
    ShowCursor;
    Screen('CloseAll');
    FlushEvents;
    rethrow(error);
end
ShowCursor;
Screen('CloseAll');
FlushEvents;
toc

function gammacor = RGBcor(raw,lumin)
% raw is RGB in 1x3, RGB values defined by design
% lumin is the luminance we want to have between 0-1
if size(raw,1)==1 & size(raw,2)==1
    raw=ones(1,3)*raw;
end
RGB = [0.300 0.590 0.110];
cor = raw./(RGB*raw')*lumin; % now cor is in 0-1 range
% cor is the values observed by the subject so that the true luminance is "lumin"
gammacor = cor.^(1/2.2);
% now gammacor is values we give to the graphics card, with a gamma correction, gamma=2.2
gammacor=gammacor*255;% put the gammacor values back in the 0-255 range
