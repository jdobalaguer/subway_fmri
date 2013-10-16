function tools_dotplot(data,leggie,markz,colz,stats)
% function dotplot(data,leggie,markz,colz);


if nargin<3;
markz={'o','o','o','o','o','o','o','+','+','+','+','+','+','+'};
end

if nargin<4
colz={'r','g','b','c','y','m','k','r','g','b','c','y','m','k'};
end

if nargin<5
    stats=0;
end

mdata=nanmean(data);
stedata=tools_nanste(data);

size_data = size(data);
if length(size_data)>2
    mdata = reshape(mdata,size_data(2:end));
    stedata = reshape(stedata,size_data(2:end));
end

barwid=20;

if nargin<2;
    for n=1:size(mdata,1);
        leggie{n}=['v',num2str(n)];
    end
end

ex=0;
for n=1:size(mdata,1);
    hold on;

    for p=1:size(mdata,2)
        
        col=colz{n};
        if stats
        [t pp]=masst(data(:,p));
        if pp>0.025 & pp<0.975 | isnan(pp);
            col=colz{n}+0.7;
            col(col>1)=1;
        end
        end
        hog(n)=plot(ex+p,mdata(n,p),markz{n},'markeredgecolor',col,'markeredgecolor',col,'markerfacecolor',col,'markersize',10);
        
        pex=p+ex;
        line([pex,pex],[mdata(n,p)-(stedata(n,p)/2),mdata(n,p)+(stedata(n,p)/2)],'color',col,'linewidth',2);
        line([pex-1/barwid,pex+1/barwid],[mdata(n,p)-(stedata(n,p)/2),mdata(n,p)-(stedata(n,p)/2)],'color',col,'linewidth',2);
        line([pex-1/barwid,pex+1/barwid],[mdata(n,p)+(stedata(n,p)/2),mdata(n,p)+(stedata(n,p)/2)],'color',col,'linewidth',2);
    end
    ex=ex+0.05;    

end

%legend(hog,leggie,'location','N');
set(gca,'fontsize',16,'fontname','Arial');
%legend boxoff;

