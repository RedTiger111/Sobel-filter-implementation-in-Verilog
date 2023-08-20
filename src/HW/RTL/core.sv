% week 1        : Modulation, Demodulation
% Student ID    : 2019314131
% Name          : Hong Seung Bum

%% 0.AWGN channel

% function [y , noise_power] = awgn(signal,SNR)

%% 1. modulation

%*************   BPSK : s(t)_BPSK    = Ac*cos(2pi*Fc*t+Pc) (phase:2)
%*************   QPSK : s(t)_BPSK    = Ac*cos(2pi*Fc*t+Pc) (phase:4)
%************  16-QAM : s(t)_16-QAM  = Ac*cos(2pi*Fc*t+Pc) (phase:2 , Amp:2)
%************  64-QAM : s(t)_64-QAM  = Ac*cos(2pi*Fc*t+Pc) (phase:3 , Amp:3)
%************ 256-QAM : s(t)_256-QAM = Ac*cos(2pi*Fc*t+Pc) (phase:4 , Amp:4)

n = input("Enter length of Bit \n")
r = input("Enter bit/symbol    \n")

bits = randi([0, 1], 1, n);
zero_num = rem(length(bits),8);                             % number of zero


data_1_bin = [bits, zeros(1,8-zero_num)];                   % 1bit data for BPSK
data_2_bin = reshape(data_1_bin,[2,length(data_1_bin)/2]);  % 2bit data for QPSK
data_4_bin = reshape(data_1_bin,[4,length(data_1_bin)/4]);  % 4bit data for 16-QAM
data_6_bin = reshape(data_1_bin,[6,length(data_1_bin)/6]);  % 6bit data for 64-QAM
data_8_bin = reshape(data_1_bin,[8,length(data_1_bin)/8]);  % 8bit data for 256-QAM

[data_1_row,data_1_col] = size(data_1_bin);
[data_2_row,data_2_col] = size(data_2_bin);
[data_4_row,data_4_col] = size(data_4_bin);
[data_6_row,data_6_col] = size(data_6_bin);
[data_8_row,data_8_col] = size(data_8_bin);

%*************  gray code  ************************************************
%*************  data_1 / data_2  ******************************************
%*************  data_8 / data_6 / data_8  *********************************

data_1 = data_1_bin;

for (j = 1:1:data_2_col)
    for (i = 1:1:data_2_row)
        if (i==1)
            data_2(i,j) = data_2_bin(i,j);
        else
            data_2(i,j) = xor(data_2_bin(i-1,j),data_2_bin(i,j));
        end
    end
end

for (j = 1:1:data_4_col)
    for (i = 1:1:data_4_row)
        if (i==1)
            data_4(i,j) = data_4_bin(i,j);
        else
            data_4(i,j) = xor(data_4_bin(i-1,j),data_4_bin(i,j));
        end
    end
end

for (j = 1:1:data_6_col)
    for (i = 1:1:data_6_row)
        if (i==1)
            data_6(i,j) = data_6_bin(i,j);
        else
            data_6(i,j) = xor(data_6_bin(i-1,j),data_6_bin(i,j));
        end
    end
end

for (j = 1:1:data_8_col)
    for (i = 1:1:data_8_row)
        if (i==1)
            data_8(i,j) = data_8_bin(i,j);
        else
            data_8(i,j) = xor(data_8_bin(i-1,j),data_8_bin(i,j));
        end
    end
end

if (r==1)
    disp(" BPSK Modulation ! \n")
    data = data_1;
elseif (r==2)
    disp(" QPSK Modulation ! \n")
    data = data_2;
elseif (r==4)
    disp(" 16-QAM Modulation ! \n")
    data = data_4;
elseif (r==6)
    disp(" 64-QAM Modulation ! \n")
    data = data_6;
elseif (r==8)
    disp(" 256-QAM Modulation ! \n")
    data = data_8;
else
    disp(" None. \n")
    data = [];
end
%****************************print what data is *******************************************************************************

disp("digital data is : \n");
disp(data)


%****************************BPSK constellation mapping************************************************************************
if (r==1)
    for (i= 1:1:data_1_col)
        if(data(:,i)==[0])
            I(i)= -1; Q(i) = 0;
        else
            I(i)=  1; Q(i) = 0;
        end
    end
    %****************************QPSK constellation mapping************************************************************************
elseif (r==2)
    for (i = 1:1:data_2_col)
        if (data(:,i)==[0 0])
            I(i) = +1;
            Q(i) = +1;
        elseif (data(:,i)==[0 1])
            I(i) = -1;
            Q(i) = +1;
        elseif (data(:,i)==[1 0])
            I(i) = +1;
            Q(i) = -1;
        else
            I(i) = -1;
            Q(i) = -1;
        end
    end
    %****************************16-QAM constellation mapping**********************************************************************
elseif (r==4)
    for (i = 1:1:data_4_col)
        if (data(1,i)==0 && data(2,i)==0)
            I(i) = -3;
        elseif (data(1,i)==0 && data(2,i)==1)
            I(i) = -1;
        elseif (data(1,i)==1 && data(2,i)==1)
            I(i) =  1;
        else
            I(i) =  3;
        end
    end
    for (i = 1:1:data_4_col)
        if (data(3,i)==1 && data(4,i)==0)
            Q(i) = -3;
        elseif (data(3,i)==1 && data(4,i)==1)
            Q(i) = -1;
        elseif (data(3,i)==0 && data(4,i)==1)
            Q(i) =  1;
        else
            Q(i) =  3;
        end
    end
    %****************************64-QAM constellation mapping**********************************************************************
elseif (r==6)
    for (i = 1:1:data_6_col)
        if((data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0) || ...
                data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1)
            I(i) = -7;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0) || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1))
            I(i) = -5;
        elseif ((data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1))
            I(i) = -3;
        elseif ((data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==1))
            I(i) = -1;
        elseif ((data(1,i)==1 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0) || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==0 && data(4,i)==1))
            I(i) = +1;
        elseif ((data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0) || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1))
            I(i) = +3;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0) || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1))
            I(i) = +5;
        else
            I(i) = +7;
        end
    end
    for (i = 1:1:data_6_col)
        if((data(1,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0))
            Q(i) = -7;
        elseif ((data(1,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1) || ...
                (data(1,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1))
            Q(i) = -5;
        elseif ((data(1,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1) || ...
                (data(1,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1))
            Q(i) = -3;
        elseif ((data(1,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0) || ...
                (data(1,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0))
            Q(i) = -1;
        elseif ((data(1,i)==0 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0) || ...
                (data(1,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0))
            Q(i) = +1;
        elseif ((data(1,i)==0 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1) || ...
                (data(1,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1))
            Q(i) = +3;
        elseif ((data(1,i)==0 && data(4,i)==1 && data(5,i)==0 && data(6,i)==1) || ...
                (data(1,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==1))
            Q(i) = +5;
        else
            Q(i) = +7;
        end
    end
    %****************************256-QAM constellation mapping*********************************************************************
else %(r=8)********************************************************************************************************************
    for (i = 1:1:data_8_col)
        if ((data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0))
            I(i) = -15;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0))
            I(i) = -13;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0))
            I(i) = -11;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0)  || ...
                (data(1,i)==0 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1))
            I(i) = -9;
        elseif ((data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0))
            I(i) = -7;
        elseif ((data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0))
            I(i) = -5;
        elseif ((data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0)  || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0)  || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0))
            I(i) = -3;
        elseif ((data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==0 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0))
            I(i) = -1;
        elseif ((data(1,i)==1 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0))
            I(i) = +1;
        elseif ((data(1,i)==1 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==0 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0))
            I(i) = +3;
        elseif ((data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0))
            I(i) = +5;
        elseif ((data(1,i)==1&& data(2,i)==1 && data(3,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(3,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==0))
            I(i) = +7;
        elseif ((data(1,i)==1 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==1 && data(4,i)==0 && data(5,i)==0 && data(6,i)==0))
            I(i) = +9;
        elseif ((data(1,i)==1 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==1 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0))
            I(i) = +11;
        elseif((data(1,i)==1 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1 && data(5,i)==0 && data(6,i)==0) || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1 && data(5,i)==0 && data(6,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1 && data(5,i)==1 && data(6,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(3,i)==0 && data(4,i)==1 && data(5,i)==1 && data(6,i)==1))
            I(i) = +13;
        else
            I(i) = +15;
        end
    end
    for (i = 1:1:data_8_col)
        if ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==0 && data(7,i)==0 && data(8,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==0 && data(6,i)==0 && data(7,i)==0 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==0 && data(7,i)==0 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==0 && data(6,i)==0 && data(7,i)==0 && data(8,i)==0))
            Q(i) = -15;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==0 && data(7,i)==0 && data(8,i)==1) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==0 && data(6,i)==0 && data(7,i)==0 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==0 && data(7,i)==0 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==0 && data(6,i)==0 && data(7,i)==0 && data(8,i)==1))
            Q(i) = -13;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==0 && data(7,i)==1 && data(8,i)==1) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==0 && data(6,i)==0 && data(7,i)==1 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==0 && data(7,i)==1 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==0 && data(6,i)==0 && data(7,i)==1 && data(8,i)==1))
            Q(i) = -11;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==0 && data(7,i)==1 && data(8,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==0 && data(6,i)==0 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==0 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==0 && data(6,i)==0 && data(7,i)==1 && data(8,i)==0))
            Q(i) = -9;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0))
            Q(i) = -7;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==1) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==1))
            Q(i) = -5;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==0 && data(8,i)==1) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==0 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==0 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==0 && data(8,i)==1))
            Q(i) = -3;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==0 && data(8,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==0 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==0 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==0 && data(8,i)==0))
            Q(i) = -1;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==1 && data(6,i)==1 && data(7,i)==0 && data(8,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==1 && data(6,i)==1 && data(7,i)==0 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==1 && data(6,i)==1 && data(7,i)==0 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0))
            Q(i) = +1;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0))
            Q(i) = +3;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==1) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==1))
            Q(i) = +5;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==0 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==1 && data(6,i)==1 && data(7,i)==1 && data(8,i)==0))
            Q(i) = +7;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==1 && data(6,i)==0 && data(7,i)==1 && data(8,i)==0) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==1 && data(6,i)==0 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==1 && data(6,i)==0 && data(7,i)==1 && data(8,i)==0)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==1 && data(6,i)==0 && data(7,i)==1 && data(8,i)==0))
            Q(i) = +9;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==1 && data(6,i)==0 && data(7,i)==1 && data(8,i)==1) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==1 && data(6,i)==0 && data(7,i)==1 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==1 && data(6,i)==0 && data(7,i)==1 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==1 && data(6,i)==0 && data(7,i)==1 && data(8,i)==1))
            Q(i) = +11;
        elseif ((data(1,i)==0 && data(2,i)==0 && data(5,i)==1 && data(6,i)==0 && data(7,i)==0 && data(8,i)==1) || ...
                (data(1,i)==0 && data(2,i)==1 && data(5,i)==1 && data(6,i)==0 && data(7,i)==0 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==1 && data(5,i)==1 && data(6,i)==0 && data(7,i)==0 && data(8,i)==1)  || ...
                (data(1,i)==1 && data(2,i)==0 && data(5,i)==1 && data(6,i)==0 && data(7,i)==0 && data(8,i)==1))
            Q(i) = +13;
        else
            Q(i) = +15;
        end
    end
end


%****************************I-Q normalization***************************************************************

if (r==1)                %***************at BPSK*************************************************************
    factor = 1;
elseif (r==2)            %***************at QPSK*************************************************************
    factor = 1/sqrt(2);
elseif (r==4)            %***************at 16-QAM***********************************************************
    factor = 1/sqrt(10);
elseif (r==6)            %***************at 64-QAM***********************************************************
    factor = 1/sqrt(4);
elseif (r==8)            %***************at 256-QAM**********************************************************
    factor = 1/sqrt(170);
else
    factor = 1;
end

for (i = 1:1:length(I))
    I_nor(i) = factor * I(i);
    Q_nor(i) = factor * Q(i);
end


%****************************I-Q mapping********************************************************************
for (i = 1:1:length(I))
    I_Q(i) = complex(I_nor(i),Q_nor(i));
end

%scatter(I_nor,Q_nor);

%*************  Modulation ******************************************************
%*************  at time domain ********************************************
bitrate = 10.^6;
Fc= bitrate;
T= 1/bitrate;
t= T/99:T/99:T;

sig_in=[];
signal=[];

for(i = 1:1:length(I))
    A(i) = abs(I_Q(i));
    P(i) = angle(I_Q(i));
end

for (i=1:1:length(I))
    sig_in = A(i)*cos(2*pi*Fc*t+P(i));
    signal = [signal sig_in];
end

tt=T/99:T/99:(T*length(data));


%*************  noise signal ******************************************************

SNR = 20;

signal_noise = awgn_noise(signal,SNR);
plot(tt,signal,'-',tt,signal_noise,'-')
I_Q_noise(i) = awgn_noise(I_Q,SNR);


%*************  Demodulation ******************************************************

% for(i=1:1:length(data))
%     Z_in=signal_noise((i-1)*length(t)+1:i*length(t)).*cos(2*pi*Fc*t);
%     Z_in_intg(i)=(trapz(t,Z_in))*(2/T);
%     Z_qd=signal_noise((i-1)*length(t)+1:i*length(t)).*sin(2*pi*Fc*t);
%     Z_qd_intg(i)=(trapz(t,Z_qd))*(2/T);
% end

for (i = 1:1:length(I_Q_noise))
    I_noise_nor(i) = real(I_Q_noise(i));
    I_noise(i)     = I_noise_nor(i)/factor;
    Q_noise_nor(i) = imag(I_Q_noise(i));
    Q_noise(i)     = Q_noise_nor(i)/factor;
end



%************* Constellation approximation ******************************************************

if (r==1)
    for(i = 1:1:length((I_noise(i))))
        if ((I_noise(i)) < 0)
            I_R(i) = -1;
            Q_R(i) = 0;
        else
            I_R(i) = +1;
            Q_R(i) = 0; 
        end
    end
elseif (r==2)
    for(i = 1:1:length((I_noise(i))))
        if ((I_noise(i)) <0)
            I_R(i) = -1;
        else
            I_R(i) = +1;
        end
        if(Q_noise(i) <0)
            Q_R(i) = -1;
        else
            Q_r(i) = +1;
        end
    end
elseif(r==4)
    for(i = 1:1:length((I_noise(i))))
        if ((I_noise(i)) <-2)
            I_R(i) = -3;
        elseif (-2<=(I_noise(i))<0)
            I_R(i) = -1;
        elseif (0<=(I_noise(i))<2)
            I_R(i) = +1;
        else
            I_R(i) = +3;
        end
        if (Q_noise(i) <-2)
            Q_R(i) = -3;
        elseif (-2<=Q_noise(i)<0)
            Q_R(i) = -1;
        elseif (0<=Q_noise(i)<2)
            Q_R(i) = +1;
        else
            Q_R(i) = +3;
        end
    end
elseif(r==6)
    for(i = 1:1:length((I_noise(i))))
        if ((I_noise(i)) <-6)
            I_R(i) = -7;
        elseif (-6<=(I_noise(i))<-4)
            I_R(i) = -5;
        elseif (-4<=(I_noise(i))<-2)
            I_R(i) = -3;
        elseif (-2<=(I_noise(i))<0)
            I_R(i) = -1;
        elseif (0<=(I_noise(i))<2)
            I_R(i) = +1;
        elseif (2<=(I_noise(i))<4)
            I_R(i) = +3;
        elseif (4<=(I_noise(i))<6)
            I_R(i) = +5;
        else
            I_R(i) = +7;
        end
        if (Q_noise(i) <-6)
            Q_R(i) = -7;
        elseif (-6<=Q_noise(i)<-4)
            Q_R(i) = -5;
        elseif (-4<=Q_noise(i)<-2)
            Q_R(i) = -3;
        elseif (-2<=Q_noise(i)<0)
            Q_R(i) = -1;
        elseif (0<=Q_noise(i)<2)
            Q_R(i) = +1;
        elseif (2<=Q_noise(i)<4)
            Q_R(i) = +3;
        elseif (4<=Q_noise(i)<6)
            Q_R(i) = +5;
        else
            Q_R(i) = +7;
        end
    end
else
    for(i = 1:1:length((I_noise(i))))
        if ((I_noise(i)) <-14)
            I_R(i) = -15;
        elseif (-14<=(I_noise(i))<-12)
            I_R(i) = -13;
        elseif (-12<=(I_noise(i))<-10)
            I_R(i) = -11;
        elseif (-10<=(I_noise(i))<-8)
            I_R(i) = -9;
        elseif (-8<=(I_noise(i))<-6)
            I_R(i) = -7;
        elseif (-6<=(I_noise(i))<-4)
            I_R(i) = -5;
        elseif (-4<=(I_noise(i))<-2)
            I_R(i) = -3;
        elseif (-2<=(I_noise(i))<0)
            I_R(i) = -1;
        elseif (0<=(I_noise(i))<2)
            I_R(i) = +1;
        elseif (2<=(I_noise(i))<4)
            I_R(i) = +3;
        elseif (4<=(I_noise(i))<6)
            I_R(i) = +5;
        elseif (6<=(I_noise(i))<8)
            I_R(i) = +7;
        elseif (8<=(I_noise(i))<10)
            I_R(i) = +9;
        elseif (10<=(I_noise(i))<12)
            I_R(i) = +11;
        elseif (12<=(I_noise(i))<14)
            I_R(i) = +13;
        else
            I_R(i) = +15;
        end
        if (Q_noise(i) <-14)
            Q_R(i) = -15;
        elseif (-14<=Q_noise(i)<-12)
            Q_R = -13;
        elseif (-12<=Q_noise(i)<-10)
            Q_R = -11;
        elseif (-10<=Q_noise(i)<-8)
            Q_R = -9;
        elseif (-8<=Q_noise(i)<-6)
            Q_R = -7;
        elseif (-6<=Q_noise(i)<-4)
            Q_R = -5;
        elseif (-4<=Q_noise(i)<-2)
            Q_R = -3;
        elseif (-2<=Q_noise(i)<0)
            Q_R = -1;
        elseif (0<=Q_noise(i)<2)
            Q_R = +1;
        elseif (2<=Q_noise(i)<4)
            Q_R = +3;
        elseif (4<=Q_noise(i)<6)
            Q_R = +5;
        elseif (6<=Q_noise(i)<8)
            Q_R = +7;
        elseif (8<=Q_noise(i)<10)
            Q_R = +9;
        elseif (10<=Q_noise(i)<12)
            Q_R = +11;
        elseif (12<=Q_noise(i)<14)
            Q_R = +13;
        else
            Q_R = +15;
        end
    end
end





