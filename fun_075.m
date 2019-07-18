function[s,d]=fun_075(n,r,m) %主函数 商人过河求解 %075队% %Lagoon%
%%%% n 为商人或仆人数
%%%% r 为小船容纳人数
%%%% m 为移动的最大步数
%%%%%%%%%%%%%%%
%此处为测试数据
%n=3;r=2;m=12; %
%n=3;r=3;m=12; %
%n=4;r=3;m=12; %
%n=4;r=4;m=12; %
%n=100;r=99;m=12;%
%以上数据均可得出正确结果
%%%%%%%%%%%%%%%
Sx=[zeros(1,n+1),n*ones(1,n+1),1:n-1];
Sy=[0:n         ,0:n          ,1:n-1];
%%%%%%Lagoon%%%%%%
% Sx为满足条件的商人数的情况，Sy为满足条件的仆人数的情况
% S=[Sx;Sy]正好构成允许状态集，但为了方便后续计算，程序中并未使用
%%%%%%Lagoon%%%%%%
s=zeros(m,3);d=zeros(m-1,3);k=1;
LEN=zeros(m-1,3);
%%%%%&Lagoon%%%%%%
% s为此岸状态的集合，s(k,1)为第k步的商人数，s(k,2)为第k步的仆人数，s(k,3)为第k步的数值
% d为决策量的集合，d(k,1)的绝对值为第k步运送的商人数，d(k,2)的绝对值为第k步运送的仆人数，d(k,3)为第k步的数值
% 其中，d(k,1)与d(k,2)中的数值为负时，表示船向对岸运送人，为正时表示向彼岸运送人
% LEN为条件集合
%%%%%%Lagoon%%%%%%
s(1,1)=n;s(1,2)=n;s(1,3)=k;
fprintf('S%d(%d,%d)->',s(k,3),s(k,1),s(k,2)),
k=k+1;t1=1;
while k<=m&&s(k-1,1)+s(k-1,2)>0
    if rem(k,2)==0
        X=Sx-s(k-1,1);Y=Sy-s(k-1,2);XY=X+Y;
        dk=find(((XY)<=-1&(XY)>=-r)&X<=0&Y<=0);
        %%%%%%Lagoon%%%%%%%
        % 当k为偶数时，x(k)-x(k-1)>=0，y(k)-y(k-1)>=0，1<=x(k)-x(k-1)+y(k)-y(k-1)<=r
        % 用dk表示满足上述条件的Sx与Sy的位置
        %%%%%%Lagoon%%%%%%%
        [~, g]=sort(XY(dk),'ascend'); %对满足条件的情况进行排序，运送人数多的情况优先排前           
        len=size(g,2);
        if t1==1
            i=1;
        end
        while i<=len %依次检验每种情况是否会出现回路，若无回路的则作为第k步的情况
            t=myfun(Sx(dk(i)),Sy(dk(i)),k,s); %检验是否会出现回路
            if t==1
                s(k,1)=Sx(dk(i));
                s(k,2)=Sy(dk(i));
                s(k,3)=k;
                d(k-1,1)=s(k,1)-s(k-1,1);
                d(k-1,2)=s(k,2)-s(k-1,2);
                d(k-1,3)=k-1;
                LEN(k-1,1)=i;
                LEN(k-1,2)=len;
                LEN(k-1,3)=k-1;
                if s(k,1)~=0||s(k,2)~=0
                    fprintf(' *d%d(%d,%d)* S%d(%d,%d)->',d(k-1,3),d(k-1,1),d(k-1,2),s(k,3),s(k,1),s(k,2)),
                else
                    fprintf(' *d%d(%d,%d)* S%d(%d,%d)\n',d(k-1,3),d(k-1,1),d(k-1,2),s(k,3),s(k,1),s(k,2)),
                end
                k=k+1;t1=1;
                break;
            end
            i=i+1;
        end
        if i>len && t==0 % 若第k步出现回路，则调用LEN中的数据查询第k-1步的情况，并选择第i+1个情况作为第k-1步的现有情况
            k=k-1;       % 若查询完毕，没有适宜的情况则中止程序
            i=LEN(k-1,1)+1;
            len=LEN(k-1,2);
            t1=0;
            if i>len
                disp('Erro!'),
                return;
            end
        end
    else
        X=Sx-s(k-1,1);Y=Sy-s(k-1,2);XY=X+Y;
        dk=find(((XY)>=1&(XY)<=r)&X>=0&Y>=0);
        %%%%%%Lagoon%%%%%%%
        % 当k为偶数时，x(k)-x(k-1)<=0，y(k)-y(k-1)<=0，-r<=x(k)-x(k-1)+y(k)-y(k-1)<=-1
        % 用dk表示满足上述条件的Sx与Sy的位置
        %%%%%%%Lagoon%%%%%%
        [~, g]=sort(XY(dk),'ascend'); %对满足条件的情况进行排序，运送人数少的情况优先排前
        len=size(g,2);
        if t1==1
            i=1;
        end
        while i<=len %依次检验每种情况是否会出现回路，若无回路的则作为第k步的情况
            t=myfun(Sx(dk(i)),Sy(dk(i)),k,s); %检验是否会出现回路
            if t==1
                s(k,1)=Sx(dk(i));
                s(k,2)=Sy(dk(i));
                s(k,3)=k;
                d(k-1,1)=s(k,1)-s(k-1,1);
                d(k-1,2)=s(k,2)-s(k-1,2);
                d(k-1,3)=k-1;
                if s(k,1)~=0||s(k,2)~=0
                    fprintf(' *d%d(%d,%d)* S%d(%d,%d)->',d(k-1,3),d(k-1,1),d(k-1,2),s(k,3),s(k,1),s(k,2)),
                else
                    fprintf(' *d%d(%d,%d)* S%d(%d,%d)\n',d(k-1,3),d(k-1,1),d(k-1,2),s(k,3),s(k,1),s(k,2)),
                end
                k=k+1;t1=1;
                break;
            end
            i=i+1;
        end
        if i>len && t==0 % 若第k步出现回路，则调用LEN中的数据查询第k-1步的情况，并选择第i+1个情况作为第k-1步的现有情况
            k=k-1;       % 若查询完毕，没有适宜的情况则中止程序
            i=LEN(k-1,1)+1;
            len=LEN(k-1,2);
            t1=0;
            if i>len
                disp('Erro!'),
                return;
            end
        end
    end
end
%fprintf('%%%% 函数产生的第一个矩阵为此岸状态的集合，第k行的第1列为第k步的商人数，第k行的第2列为第k步的仆人数，第k行的第3列为第k步的数值\n');
%fprintf('%%%% 函数产生的第二个矩阵为决策量的集合，第k行的第1列的绝对值为第k步运送的商人数，第k行的第2列的绝对值为第k步运送的仆人数，第k行的第3列为第k步的数值\n');
end
function[t]=myfun(sx,sy,k,s) %判断是否有回路 返回值t=0则存在回路 t=1则无回路
t=1;m=size(s,1);
if rem(k,2)==0
    j=2;
else
    j=1;
end
while j<=m && s(j,3)~=0
    if s(j,1)==sx&&s(j,2)==sy
        t=0;
        break;
    end
    j=j+2;
end
end