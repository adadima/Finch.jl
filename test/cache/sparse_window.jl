@inbounds begin
        C_lvl = ex.body.lhs.tns.tns.lvl
        C_lvl_pos_alloc = length(C_lvl.pos)
        C_lvl_idx_alloc = length(C_lvl.idx)
        C_lvl_2 = C_lvl.lvl
        C_lvl_2_val_alloc = length(C_lvl.lvl.val)
        C_lvl_2_val = 0.0
        A_lvl = ex.body.rhs.tns.tns.lvl
        A_lvl_pos_alloc = length(A_lvl.pos)
        A_lvl_idx_alloc = length(A_lvl.idx)
        A_lvl_2 = A_lvl.lvl
        A_lvl_2_val_alloc = length(A_lvl.lvl.val)
        A_lvl_2_val = 0.0
        i_start = 2 + (1 - 2)
        i_stop = 4 + (1 - 2)
        C_lvl_pos_alloc = length(C_lvl.pos)
        C_lvl_pos_fill = 1
        C_lvl.pos[1] = 1
        C_lvl.pos[2] = 1
        C_lvl_idx_alloc = length(C_lvl.idx)
        C_lvl_2_val_alloc = (Finch).refill!(C_lvl_2.val, 0.0, 0, 4)
        C_lvl_pos_alloc < 1 + 1 && (C_lvl_pos_alloc = (Finch).refill!(C_lvl.pos, 0, C_lvl_pos_alloc, 1 + 1))
        C_lvl_q = C_lvl.pos[C_lvl_pos_fill]
        for C_lvl_p = C_lvl_pos_fill:1
            C_lvl.pos[C_lvl_p] = C_lvl_q
        end
        A_lvl_q = A_lvl.pos[1]
        A_lvl_q_stop = A_lvl.pos[1 + 1]
        if A_lvl_q < A_lvl_q_stop
            A_lvl_i = A_lvl.idx[A_lvl_q]
            A_lvl_i1 = A_lvl.idx[A_lvl_q_stop - 1]
        else
            A_lvl_i = 1
            A_lvl_i1 = 0
        end
        i = i_start
        i_start_2 = i
        phase_start = max(i_start_2)
        phase_stop = min(i_stop, A_lvl_i1 + -1)
        if phase_stop >= phase_start
            i = i
            i = phase_start
            while A_lvl_q < A_lvl_q_stop && A_lvl.idx[A_lvl_q] < phase_start + -((1 - 2))
                A_lvl_q += 1
            end
            while i <= phase_stop
                i_start_3 = i
                A_lvl_i = A_lvl.idx[A_lvl_q]
                phase_start_2 = max(i_start_3)
                phase_stop_2 = min(phase_stop, A_lvl_i + -1)
                if phase_stop_2 >= phase_start_2
                    i_2 = i
                    if A_lvl_i == phase_stop_2 + -((1 - 2))
                        A_lvl_2_val = A_lvl_2.val[A_lvl_q]
                        i_3 = phase_stop_2
                        C_lvl_2_val_alloc < C_lvl_q && (C_lvl_2_val_alloc = (Finch).refill!(C_lvl_2.val, 0.0, C_lvl_2_val_alloc, C_lvl_q))
                        C_lvl_isdefault = true
                        C_lvl_2_val = 0.0
                        C_lvl_isdefault = false
                        C_lvl_2_val = A_lvl_2_val
                        C_lvl_2.val[C_lvl_q] = C_lvl_2_val
                        if !C_lvl_isdefault
                            C_lvl_idx_alloc < C_lvl_q && (C_lvl_idx_alloc = (Finch).regrow!(C_lvl.idx, C_lvl_idx_alloc, C_lvl_q))
                            C_lvl.idx[C_lvl_q] = i_3
                            C_lvl_q += 1
                        end
                        A_lvl_q += 1
                    else
                    end
                    i = phase_stop_2 + 1
                end
            end
            i = phase_stop + 1
        end
        i_start_2 = i
        phase_start_3 = max(i_start_2)
        phase_stop_3 = min(i_stop)
        if phase_stop_3 >= phase_start_3
            i_4 = i
            i = phase_stop_3 + 1
        end
        C_lvl.pos[1 + 1] = C_lvl_q
        C_lvl_pos_fill = 1 + 1
        (C = Fiber((Finch.SparseListLevel){Int64}(4 + (1 - 2), C_lvl.pos, C_lvl.idx, C_lvl_2), (Finch.Environment)(; name = :C)),)
    end
