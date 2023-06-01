%%% PMMA�� n, k�� ���ϴ� �Լ�
% - lambda : 250nm ~ 1000nm
% - Using Lagrange interpolation

function result=fun_PMMA_nk(lambda)

lambda=lambda*10^9;

PMMA_data=[ 250	1.6246  0; 260	1.6141  0; 270	1.602   0; 280	1.5905  0;
290	1.581   0; 300	1.575   0; 310	1.5689  0; 320	1.5634  0; 330	1.5584  0; 
340	1.5539  0; 350	1.5489  0; 360	1.5444  0; 370	1.5413  0; 380	1.5378  0; 
390	1.5343  0; 400	1.5303  0; 410	1.5263  0; 420	1.5233  0; 430	1.5193  0; 
440	1.5163  0; 450	1.5138  0; 460	1.5117  0; 470	1.5097  0; 480	1.5082  0;
490	1.5072  0; 500	1.5057  0; 510	1.5047  0; 520	1.5042  0;  530	1.5037  0; 
540	1.5032  0; 550	1.5027  0; 560	1.5017  0; 570	1.5012  0; 580	1.5007  0; 
590	1.5007  0; 600	1.5002  0; 610	1.4997  0; 620	1.4997  0; 630	1.4992  0;
640	1.4992  0; 650	1.4987  0; 660	1.4987  0; 670	1.4982  0; 680	1.4982  0;
690	1.4977  0; 700	1.4977  0; 710	1.4977  0; 720	1.4977  0; 730	1.4972  0;
740	1.4972  0; 750	1.4972  0; 760	1.4972  0; 770	1.4972  0; 780	1.4972  0;
790	1.4967  0; 800	1.4967  0; 810	1.4967  0; 820	1.4967  0; 830	1.4967  0;
840	1.4967  0; 850	1.4967  0; 860	1.4967  0; 870	1.4967  0; 880	1.4967  0;
890	1.4967  0; 900	1.4967  0; 910	1.4967  0; 920	1.4967  0; 930	1.4967  0;
940	1.4967  0; 950	1.4967  0; 960	1.4967  0; 970	1.4967  0; 980	1.4962  0;
990	1.4962  0; 1000	1.4962  0 ];

PMMA_data_length=length(PMMA_data(:,1));
for cnt=1:PMMA_data_length-1
    if (lambda>=PMMA_data(cnt,1))&(lambda<PMMA_data(cnt+1,1))
        break;
    end
end

%%% Lagrange interpolation %%%
xi=PMMA_data(cnt,1);     ni=PMMA_data(cnt,2);   ki=PMMA_data(cnt,3);
xj=PMMA_data(cnt+1,1);   nj=PMMA_data(cnt+1,2); kj=PMMA_data(cnt+1,3);
x=lambda;

n=(x-xj)/(xi-xj)*ni+(x-xi)/(xj-xi)*nj;
k=(x-xj)/(xi-xj)*ki+(x-xi)/(xj-xi)*kj;

result=n+j*k;