@inbounds begin
        B_lvl = ex.body.lhs.tns.tns.lvl
        B_lvl_2 = B_lvl.lvl
        B_lvl_2_val_alloc = length(B_lvl.lvl.val)
        B_lvl_2_val = 0.0
        A_lvl = ex.body.rhs.tns.tns.lvl
        A_lvl_pos_alloc = length(A_lvl.pos)
        A_lvl_idx_alloc = length(A_lvl.idx)
        A_lvl_val_alloc = length(A_lvl.val)
        i_stop = A_lvl.I
        B_lvl_2_val_alloc = (Finch).refill!(B_lvl_2.val, 0.0, 0, 4)
        B_lvl_2_val_alloc < 1 * A_lvl.I && (B_lvl_2_val_alloc = (Finch).refill!(B_lvl_2.val, 0.0, B_lvl_2_val_alloc, 1 * A_lvl.I))
        A_lvl_q = A_lvl.pos[1]
        A_lvl_q_stop = A_lvl.pos[1 + 1]
        if A_lvl_q < A_lvl_q_stop
            A_lvl_i = A_lvl.idx[A_lvl_q]
            A_lvl_i1 = A_lvl.idx[A_lvl_q_stop - 1]
        else
            A_lvl_i = 1
            A_lvl_i1 = 0
        end
        i = 1
        while A_lvl_q < A_lvl_q_stop && A_lvl.idx[A_lvl_q] < 1
            A_lvl_q += 1
        end
        while i <= i_stop
            i_start = i
            A_lvl_i = A_lvl.idx[A_lvl_q]
            phase_start = max(i_start)
            phase_stop = min(A_lvl_i, i_stop)
            i = i
            if A_lvl_i == phase_stop
                for i_2 = phase_start:phase_stop
                    B_lvl_q = (1 - 1) * A_lvl.I + i_2
                    B_lvl_2_val = 0.0
                    B_lvl_2_val = A_lvl.val[A_lvl_q]
                    B_lvl_2.val[B_lvl_q] = B_lvl_2_val
                end
                A_lvl_q += 1
            else
                for i_3 = phase_start:phase_stop
                    B_lvl_q = (1 - 1) * A_lvl.I + i_3
                    B_lvl_2_val = 0.0
                    B_lvl_2_val = A_lvl.val[A_lvl_q]
                    B_lvl_2.val[B_lvl_q] = B_lvl_2_val
                end
            end
            i = phase_stop + 1
        end
        (B = Fiber((Finch.DenseLevel){Int64}(A_lvl.I, B_lvl_2), (Finch.Environment)(; name = :B)),)
    end
