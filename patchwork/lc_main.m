%coded by Chang Liu(James Ruslin:hichangliu@mail.ustc.edu.cn) in 5/3/2022
bw = [0, 1, 1, 1, 0, 1, 0, 0, 0, 1;...
        1, 0, 1, 0, 0, 0, 0, 1, 1, 0;...
        0, 1, 0, 1, 0, 0, 1, 0, 0, 0;...
        0, 0, 0, 1, 1, 1, 0, 1, 1, 1;...
        0, 1, 1, 0, 1, 1, 0, 1, 0, 0;...
        1, 0, 0, 0, 0, 1, 1, 0, 0, 0;...
        1, 1, 0, 1, 1, 1, 1, 0, 1, 1;...
        0, 1, 1, 0, 0, 0, 1, 1, 0, 1;...
        1, 1, 0, 1, 1, 0, 0, 0, 0, 0;...
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
bw = reshape(bw,10*10,[]);
bw = bw(1:60);
% bw = randi(2,10*10,1)-1;
delta = 0.8;
% [snr, N, M, G,Q_F_W,Q_feature] = rfdlm_embed(500000,'E:\FMA_dataset\fma_wav\val\val\127298.wav', 'out.wav', bw, delta);
[snr, N, M, G,Q_F_W,Q_feature] = rfdlm_embed(500000,'a.wav', 'out.wav', bw, delta);
[acc,wrong_mask] = rfdlm_extract(500000,'lla_out.wav', bw, delta,Q_F_W,Q_feature);
