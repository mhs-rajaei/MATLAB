function [f] = F(x,u,fun_sel)
f = 0;
switch fun_sel
    case 1
        f  =  -20*exp(-0.2*sqrt((1/10)*sum(x.^2))) - exp((1/10)*sum(cos(2*pi*x))) + 20 + exp(1);
        %%
    case 2
        for i=1:10
            tmp = 0;
            for j=1:i
                tmp = tmp + x(i,:)^2;
            end
            f = f +tmp;
        end
        
        %%
    case 3
        for i=1:10
            f = f + x(i,:)^2 - 10 * cos(2*pi*x(i,:));
        end
        f = 10*10 + f;
        
        %%
    case 4
        for i=1:2
            f = f + -x(i,:) * sin(sqrt(abs(x(i,:))));
        end
        %%
    case 5
        for i=1:5
            f = f + (x(i,:) * sin(x(i,:)) * sin(((i*x(i,:)^2)/pi))^(2*10));
        end
        f= f*-1;
        %% No supported function
    otherwise
        error('wrong function selection');
end

end

