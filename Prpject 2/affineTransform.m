function cq=affineTransform(cp,R,ct)

  cp_r=R*cp;  %cp rotated

  cq=cp_r+ct;

end