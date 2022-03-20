%clear all;
%��ȡˮӡ
watermark = pwnlcm('eg.jpg');
watermark = watermark *1;
%��ȡ������Ƶ
[cover_audio,fs,nbits]=wavread('folk1.wav');
%������Ƶ����
len=length(cover_audio);
% %��Ƶ�ֶ���
% seg_number=24;
% %ÿ����Ƶ����
% seg_len=fix(len/seg_number);    %fix()����0ȡ��
% %seg_len = floor(seg_len/4)*4;
seg_len=10000;
seg_number=floor(len/seg_len);
%ͬ���볤��
syn_len=32;
%����ͬ����
syn_code = syn_generate(0.01,0.5,0.1,syn_len);
%payload
NP = seg_number/(len*nbits);
%����Ƕͬ����ķֶ�PA����
pa_len = 1024;
%����Ƶ�ֶ�
[ PA,PB,rest_audio ] = partition( cover_audio,seg_len,seg_number,pa_len,len );
%��ͬ����Ƕ�뵽PA
Q = 0.001; %Q��ʾǶ��ǿ��
PA_syn = syn_embed(PA,syn_code,syn_len,Q);
% test_audio = integrate( PA_syn,PB,rest_audio,seg_number );
%��ˮӡǶ�뵽PB��Ƕ��ǿ��lambda
lambda = 0.42;
PB_watermark=embedding(lambda,PB,seg_number,watermark);
% w = watermark_extraction( seg_number,PB_watermark,PB,lambda );
% clear PB;
% w = decrypt(w);
test_audio = integrate( PA_syn,PB_watermark,rest_audio,seg_number );
SNR = computeSNR( test_audio,cover_audio );
% 
% %extract_watermark = extraction(lambda,Q,test_audio,cover_audio,syn_len);
% MBER = mValue(test_audio,lambda,PB_watermark,cover_audio,seg_number,pa_len,fs,watermark);
% wavwrite(test_audio,fs,16,'LP_audio.wav');

%------------------------ѹ������--------------------------%
    mp3write(test_audio,fs,'temp.mp3');
    MP_audio = mp3read('temp.mp3');
    [ ~,MP_PB,~] = partition( MP_audio,seg_len,seg_number,pa_len,len );
    clear MP_audio;
    MP_watermark = watermark_extraction( seg_number,MP_PB,PB,lambda );
    MP=decrypt(MP_watermark);
    imwrite(im2uint8(mat2gray(MP)),'0.42MP.jpg');
    clear MP_PB;
    MP_BER  = computeBER(MP_watermark,watermark);
    MP_corr =  corr(MP_watermark,watermark);
    clear MP_watermark;
%-----------------------������------------------------%
    test_audio = integrate( PA,PB_watermark,rest_audio,seg_number );
    clear rest_audio PA;
    wavwrite(test_audio,fs,8,'temp.wav');
    [RQ_audio,fs,~]=wavread('temp.wav');
     [ ~,RQ_PB,~ ]=partition( RQ_audio,seg_len,seg_number,pa_len,len );
     clear RQ_audio;
    RQ_watermark = watermark_extraction( seg_number,RQ_PB,PB,lambda );
    RQ=decrypt(RQ_watermark);
    imwrite(im2uint8(mat2gray(RQ)),'0.42RQ.jpg');
    clear RQ_PB;
    RQ_BER = computeBER(RQ_watermark,watermark);
    RQ_corr =  corr(RQ_watermark,watermark);
    clear RQ_watermark;
% %----------------------��ֵ�޸�-----------------------%
    AM_PB = PB_watermark*0.9;
    clear PB_watermark;
    AM_watermark = watermark_extraction( seg_number,AM_PB,PB,lambda );
    AM=decrypt(AM_watermark);
    imwrite(im2uint8(mat2gray(AM)),'0.42AM.jpg');
    clear AM_PB;
    AM_BER = computeBER(AM_watermark,watermark);
    AM_corr =  corr(AM_watermark,watermark);
    clear AM_watermark;
%------------------------�ز���------------------------%
    temp_audio = resample(test_audio,fs/2,fs); 
    RS_audio = resample(temp_audio,fs,fs/2); 
    clear temp_audio;
    [ ~,RS_PB,~ ]=partition( RS_audio,seg_len,seg_number,pa_len,len );
    clear RS_audio;
    RS_watermark = watermark_extraction( seg_number,RS_PB,PB,lambda );
    RS=decrypt(RS_watermark);
    imwrite(im2uint8(mat2gray(RS)),'0.42RS.jpg');
    clear RS_PB;
    RS_BER = computeBER(RS_watermark,watermark);
    RS_corr =  corr(RS_watermark,watermark);
    clear RS_watermark;
%-----------------------������������˹��---------------------%
    GN_audio = awgn(test_audio,30);
    [ ~,GN_PB,~ ]=partition( GN_audio,seg_len,seg_number,pa_len,len );
    clear GN_audio;
    GN_watermark = watermark_extraction( seg_number,GN_PB,PB,lambda );
    GN=decrypt(GN_watermark);
    imwrite(im2uint8(mat2gray(GN)),'0.42GN.jpg');
    clear GN_PB;
    GN_BER = computeBER(GN_watermark,watermark);
    GN_corr =  corr(GN_watermark,watermark);
    clear GN_watermark;

%--------------------------��ͨ�˲�����----------------------------%
%     B =[0.0062,0.0187,0.0187,0.0062]; % ����ϵ��
%     A =[1,-2.1706,1.6517,-0.4312]; % ��ĸϵ��
    B =[0.0062,0.0187,0.0187,0.0062]; % ����ϵ��
    A =[1,-2.1706,1.6517,-0.4312]; % ��ĸϵ��
    LF_audio=filter(B,A,test_audio);
    [ ~,LF_PB,~ ]=partition( LF_audio,seg_len,seg_number,pa_len,len );
    clear LF_audio;
    LF_watermark = watermark_extraction( seg_number,LF_PB,PB,lambda );  
    LF=decrypt(LF_watermark);
    imwrite(im2uint8(mat2gray(LF)),'0.42LF.jpg');
    clear LF_PB;
    LF_BER = computeBER(LF_watermark,watermark);
    LF_corr =  corr(LF_watermark,watermark);
    clear LF_watermark;
%------------------------��ֵ�˲�-----------------------------%

    MF_audio = medfilt1(test_audio,3);
    [ ~,MF_PB,~ ]=partition( MF_audio,seg_len,seg_number,pa_len,len );
    clear MF_audio;
    MF_watermark = watermark_extraction( seg_number,MF_PB,PB,lambda );
    MF=decrypt(MF_watermark);
    imwrite(im2uint8(mat2gray(MF)),'0.42MF.jpg');
    MF_BER = computeBER(MF_watermark,watermark);
    MF_corr =  corr(MF_watermark,watermark);
    clear MF_watermark;
 
%-----------------------����----------------------------------%
    CP_audio = test_audio;
    for i=5:400:len
        CP_audio(i) = 0;
    end
    [ ~,CP_PB,~ ]=partition( CP_audio,seg_len,seg_number,pa_len,len );
    clear CP_audio;
    CP_watermark = watermark_extraction( seg_number,CP_PB,PB,lambda );
    CP=decrypt(CP_watermark);
    imwrite(im2uint8(mat2gray(CP)),'0.42CP.jpg');
    CP_BER = computeBER(CP_watermark,watermark);
    CP_corr =  corr(CP_watermark,watermark);
    clear CP_watermark;
%---------------------����ƽ��NCֵ----------------------------%
% MNC = (AM_NC+RQ_NC+RS_NC+GN_NC+LF_NC+MF_NC)/6;
%----------------------����ƽ��BERֵ--------------------------%
MBER = (MP_BER+AM_BER+RQ_BER+RS_BER+GN_BER+LF_BER+MF_BER+CP_BER)/8;
M_corr = (MP_corr+AM_corr+RQ_corr+RS_corr+GN_corr+LF_corr+MF_corr+CP_corr)/8;



