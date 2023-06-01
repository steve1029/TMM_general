% PRCWA_Gen_inout_Kb

% up & down direction wavevector components
bki=k0*ni;       % down input region wavenumber
bkf=k0*nf;       % up output region wavenumber
                        
bkiz=kx0; % incident wave�� ky
bkiy=ky0;          % incident wave�� kz
bkix=sqrt(bki^2-bkiy^2-bkiz^2); % incident wave�� kx
bkfx=sqrt(bkf^2-bkiy^2-bkiz^2); % transverse ������ k�� ��x�ǹǷ�

% region I : incident & reflection 
bkz_ref=zeros(NBx,1);   % supported mode number in x direction
bky_ref=zeros(NBy,1);   % supported mode number in y direction
bkx_ref=zeros(NBx,NBy); % supported mode number in z direction
R=zeros(NBx*NBy,1);  

for k=1:NBx
for l=1:NBy  
	bkz_ref(k)=bkiz+(k-(nz+1))*(2*pi/Tz); 
	bky_ref(l)=bkiy+(l-(ny+1))*(2*pi/Ty); 
	bkx_ref(k,l)=k0*(ni^2-(bkz_ref(k)/k0)^2-(bky_ref(l)/k0)^2)^0.5;	
end;
end;

% region II : transmission
bkz_tra=zeros(NBx,1);  	 % supported mode number in x direction
bky_tra=zeros(NBy,1);  	 % supported mode number in y direction
bkx_tra=zeros(NBx,NBy);  % supported mode number in z direction
T=zeros(NBx*NBy,1);  
for k=1:NBx
for l=1:NBy
   bkz_tra(k)=bkz_ref(k);
   bky_tra(l)=bky_ref(l);
   bkx_tra(k,l)=k0*(nf^2-(bkz_ref(k)/k0)^2-(bky_ref(l)/k0)^2)^0.5;
end;    % for l
end;	% for k