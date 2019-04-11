function sr_ciezk = srodekciezkosci(f, A)
    num = (A.^2)'*f;
    sr_ciezk = num / sum(A.^2);
