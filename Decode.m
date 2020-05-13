function Img =  Decode(EncodedVectors)
L = length(EncodedVectors);
BlocksSet = struct('Block',  zeros(8,  8,  3));
BlockSize = 8;
global Mp Np QuantizationMatrix;
Img = uint8(zeros(Mp,  Np,  3));

NewEncodedVectors = struct('EncVector', zeros(1, 64, 3));

for i = 1:L
    l_ = length(EncodedVectors(1, i).EncVector);
    NewEncodedVectors(1, i).EncVector(1, 1:l_, :) = EncodedVectors(1, i).EncVector;
    NewEncodedVectors(1, i).EncVector(1, l_:64, :) = zeros(1, 64-l_+1, 3);
end

EncodedVectors = NewEncodedVectors;
clear NewEncodedVectors;

% Decode Blocks
for i = 1:L
    BlocksSet(1,  i).Block = Irle(EncodedVectors(1,  i).EncVector);
end

% De - Quantizing The Transformed Blocks
for i = 1:L
    BlocksSet(1,  i).Block = round(QuantizationMatrix.*BlocksSet(1,  i).Block);
end


% Inverse Discrete Cosine Transform For Each Block
for i = 1:L
    block(:,  :,  1) = idct2(BlocksSet(1,  i).Block(:,  :,  1));
    block(:,  :,  2) = idct2(BlocksSet(1,  i).Block(:,  :,  2));
    block(:,  :,  3) = idct2(BlocksSet(1,  i).Block(:,  :,  3));
    BlocksSet(1,  i).Block = block;
end

% Combine The 8*8 Blocks Into One image
K  =  1;
for ROW = 1:BlockSize:Mp - BlockSize  + 1
    for COL = 1:BlockSize:Np - BlockSize  + 1
        Img(ROW:ROW  + BlockSize - 1,  COL:COL  + BlockSize - 1,  :) = BlocksSet(1,  K).Block;
        K  =  K  + 1;
    end
end

% Shift Forward The Image By 128
Img  =  Img  + 0.128;

% Convert Img To RGB Space
Img  =  ycbcr2rgb(Img);
end

