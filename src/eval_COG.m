function sr_ciezk = eval_COG(f, A)
    num = ((A.^2)')*f;
    sr_ciezk = num / sum(A.^2);
