function sr_ciezk = eval_COG(f, A)
    num = ((A.^2)')*f;
    if sum(A.^2) ~= 0
        sr_ciezk = num / sum(A.^2);
    else
        sr_ciezk = 0;
    end
