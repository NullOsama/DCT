function EncodedVectors   =   Encode(Img)
global Mp Np;
BlocksSet   =   struct('Block',  uint64(zeros(8,  8,  3)));
BlockSize  =  8;
global QuantizationMatrix CompressionFactor;
QuantizationMatrix  =  [16 11 10 16 24 40 51 61
    12 12 14 19 26 58 60 55
    14 13 16 24 40 57 69 56
    14 17 22 29 51 87 80 62
    18 22 37 56 68 109 103 77
    24 35 55 64 81 104 113 92
    49 64 78 87 103 121 120 101
    72 92 95 98 112 100 103 99
    ];

if CompressionFactor > 50
    QuantizationMatrix  =  QuantizationMatrix * ((100 - CompressionFactor) / 50);
else
    QuantizationMatrix  =  QuantizationMatrix * (50 / CompressionFactor);
end

% Convert Img To YCbCr Space
Img  =  rgb2ycbcr(Img);

% Shift Back The Image By 128
Img  =  Img - 0.128;

% Divide The Image Into Set Of 8*8 Blocks
K  =  1;
for ROW   =   1:BlockSize:Mp - BlockSize  + 1
    for COL   =   1:BlockSize:Np - BlockSize  + 1
        BlocksSet(1,  K).Block   =   uint64(Img(ROW:ROW  + BlockSize - 1,  COL:COL  + BlockSize - 1,  :));
        K  =  K  + 1;
    end
end

% Discrete Cosine Transform For Each Block
for i  =  1:K - 1
    block(:,  :,  1)   =   dct2(BlocksSet(1,  i).Block(:,  :,  1));
    block(:,  :,  2)   =   dct2(BlocksSet(1,  i).Block(:,  :,  2));
    block(:,  :,  3)   =   dct2(BlocksSet(1,  i).Block(:,  :,  3));
    BlocksSet(1,  i).Block   =   block;
end

% Quantizing The Transformed Blocks
for i  =  1:K - 1
    BlocksSet(1,  i).Block   =   round(BlocksSet(1,  i).Block./QuantizationMatrix);
end

% Encode The Blocks To Encoded Vectors
EncodedVectors   =   struct('EncVector',  uint32(zeros(1,  64,  3)));
for i   =   1:K - 1
    EncodedVectors(1,  i).EncVector   =   rle(BlocksSet(1,  i).Block);
end

ReducedVectors = struct('EncVector', uint64(zeros()));
for i   =   1:K - 1
    l = length(EncodedVectors(1,  i).EncVector);
    for j = 2:l-1
        if ~EncodedVectors(1,  i).EncVector(1, j-1, 1)&&~EncodedVectors(1,  i).EncVector(1, j, 1)&& ...
                ~EncodedVectors(1,  i).EncVector(1, j+1, 1)
            ReducedVectors(1, i).EncVector = EncodedVectors(1, i).EncVector(1, 1:j, :);
            break;
        end
    end
end
EncodedVectors = ReducedVectors;
end
