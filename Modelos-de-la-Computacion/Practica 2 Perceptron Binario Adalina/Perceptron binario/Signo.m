function Out=Signo(inp)
Out=sign(inp);
Out(Out==-1)=0;

%    if inp <= 0
%        Out = 0;
%    else
%        Out = 1;
%    end 