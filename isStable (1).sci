function [stable] = isStable(tf)
    // isStable function for SISO continuous time transfer function
    // Example 
    // s = %s ;
    // sys = syslin('c',(s+8)/(s^3+8*s^2+7*s+9)) ;
    // isStable(sys) 
    stable = %T   //True ;
    if (degree(tf.num)>degree(tf.den))
        stable = %F ;
    end
    root = roots(tf.den)
    for i = 1:length(root)
        if (real(root(i)) >= 0)
            stable = %F ;
        end 
    end  
endfunction
