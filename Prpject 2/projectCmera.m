function [P,D]=projectCmera(w,cv,cx,cy,p)

  [n,~]=size(p);
  P=zeros(2,n);
  D=zeros(1,n);

  cz=cross(cx,cy);
  p_ccs= systemtransformation(p,cv,cx,cy,p) %Going from WCS to CCS


  for i=1:n
    if p_ccs(3,1)> 0 % if condition is true then the point can be seen from the camera,else we ignore it
    
      D(1,i)= w*p_Ccs(3,i);
      P(1,i)= -w*p_ccs(1,i) / p_ccs(3,i);
      P(2,i)= -w*p_ccs(2,i) / p_ccs(3,i);

    end
  
  end

end 