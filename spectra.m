[readVoice, fs] = audioread('./input/myonvoice.wav');   % 音を読み込む
% sound(readVoice, fs); % 音を鳴らす
monoVoice = readVoice(:, 1);    % 1チャンネルにする(ステレオからモノラルに変換)
sigLen = length(monoVoice); % 長さを測る
fftLen = 4096; % フーリエ変換長
shiftLen = fftLen / 2; % シフト長
monoVoice = [monoVoice; zeros(shiftLen-mod(length(monoVoice), shiftLen), 1)]; % 信号の長さ調節(STFT用)
adjustment = ceil(sigLen/shiftLen)-1;   % 格納する行列の列数
spectrogram = zeros(fftLen, adjustment);    % 格納する行列のサイズを定義
for iIter = 1 : adjustment % 繰り返し回数はスペクトログラムの列数です
    cutSig = monoVoice(1+shiftLen*(iIter-1) : fftLen+shiftLen*(iIter-1));  % 信号の切り出し
    multiSig = cutSig .* hamming(fftLen);   % 切り出した信号に窓関数をかける  （要素毎の積）                    
    monoSpec = fft(multiSig);    % 信号をフーリエ変換してスペクトルを得る
    spectrogram(:, iIter) = monoSpec;   % スペクトルをスペクトログラムに格納する
end
powerSpec = abs(spectrogram) .^ 2; % パワースペクトル表示
powerSpec = 10*log10(powerSpec);    % パワースペクトルをデシベルで表示
createfigure(powerSpec(1:fftLen/2+1, :)) % パワースペクトル表示