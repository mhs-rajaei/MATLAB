clear all;
%Read first sheet or KDD Training+ from NSL-KDD Dataset Processd with R
[KDD_Training_p_num_5class_target,KDD_Training_p_txt_5class_target,~] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\Training_p-R.csv');
%Read seecond sheet or  20% KDD Training+ from NSL-KDD Dataset Processd with R
[Twenty_Percent_KDD_Training_p_num_5class_target,Twenty_Percent_KDD_Training_p_txt_5class_target,~] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\Twenty_Training_p-R.csv');
%Read third sheet or KDD Test+ from NSL-KDD Dataset Processd with R
[KDD_Test_p_num_5class_target,KDD_Test_p_txt_5class_target,~] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\Test_p-R.csv');
%Read forth sheet or KDD Test(-21) from NSL-KDD Dataset Processd with R
[KDD_Test_mines21_num_5class_target,KDD_Test_mines21_txt_5class_target,~] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\Test_mines21-R.csv');

%% Set targets -> norma:1 and DoS:2 & Probing:3 & R2L:4 & U2R:5
KDD_Training_p_num_5class_target_labels = zeros(5,size(KDD_Training_p_num_5class_target,1))';
for i=1:size(KDD_Training_p_num_5class_target,1)
    % trainig
    % Set targets -> norma:1 and DoS:2 & Probing:3 & R2L:4 & U2R:5
  label = KDD_Training_p_txt_5class_target{i};
    switch label
       % DoS
       case {'back', 'land', 'neptune', 'pod', 'smurf', 'teardrop',...
               'apache2', 'mailbomb', 'processtable', 'dosnuke','tcpreset', 'syslogd', 'crashiis', 'arppoison',...
               'udpstorm'}
          KDD_Training_p_num_5class_target(i,42) = 2;
        % Probing  
       case {'ipsweep', 'nmap', 'portsweep', 'satan','mscan', 'saint', 'queso',...
               'msscan','ntinfoscan', 'lsdomain', 'illegal_sniffer'}
          KDD_Training_p_num_5class_target(i,42) = 3;
        % R2L
        case {'dict', 'netcat', 'sendmail', 'imap', 'ncftp', 'xlock', 'xsnoop', 'sshtrojan',...
                'framespoof', 'ppmacro', 'guest', 'netbus', 'snmpget', 'ftp_write',...
                'phf', 'named','guess_passwd','multihop','spy',...
                'snmpgetattack','snmpguess','warezmaster','warezclient', 'ftpwrite','worm'}
          KDD_Training_p_num_5class_target(i,42) = 4;
       % U2R
       case {'buffer_overflow', 'perl', 'loadmodule', 'rootkit',...
                'ps', 'sqlattack', 'xterm','bufferoverflow', ...
               'sechole', 'eject', 'nukepw', 'secret', 'yaga', 'fdformat',...
               'ffbconfig', 'casesen', 'ntfsdos','httptunnel'}
          KDD_Training_p_num_5class_target(i,42) = 5;
      % Normal    
       otherwise
          KDD_Training_p_num_5class_target(i,42) = 1;
    end
    KDD_Training_p_num_5class_target_labels(i,KDD_Training_p_num_5class_target(i,42)) = 1;
end
% test
KDD_Test_p_num_5class_target_labels = zeros(5,size(KDD_Test_p_num_5class_target,1))';
for i=1:size(KDD_Test_p_num_5class_target,1)
    % Set targets -> norma:1 and DoS:2 & Probing:3 & R2L:4 & U2R:5
  label = KDD_Test_p_txt_5class_target{i};
    switch label
       % DoS
       case {'back', 'land', 'neptune', 'pod', 'smurf', 'teardrop',...
               'apache2', 'mailbomb', 'processtable', 'dosnuke','tcpreset', 'syslogd', 'crashiis', 'arppoison',...
               'udpstorm'}
          KDD_Test_p_num_5class_target(i,42) = 2;
        % Probing  
       case {'ipsweep', 'nmap', 'portsweep', 'satan','mscan', 'saint', 'queso',...
               'msscan','ntinfoscan', 'lsdomain', 'illegal_sniffer'}
          KDD_Test_p_num_5class_target(i,42) = 3;
        % R2L
        case {'dict', 'netcat', 'sendmail', 'imap', 'ncftp', 'xlock', 'xsnoop', 'sshtrojan',...
                'framespoof', 'ppmacro', 'guest', 'netbus', 'snmpget', 'ftp_write',...
                'phf', 'named','guess_passwd','multihop','spy',...
                'snmpgetattack','snmpguess','warezmaster','warezclient', 'ftpwrite','worm'}
          KDD_Test_p_num_5class_target(i,42) = 4;
       % U2R
       case {'buffer_overflow', 'perl', 'loadmodule', 'rootkit',...
                'ps', 'sqlattack', 'xterm','bufferoverflow', ...
               'sechole', 'eject', 'nukepw', 'secret', 'yaga', 'fdformat',...
               'ffbconfig', 'casesen', 'ntfsdos','httptunnel'}
          KDD_Test_p_num_5class_target(i,42) = 5;
      % Normal    
       otherwise
          KDD_Test_p_num_5class_target(i,42) = 1;
    end
    KDD_Test_p_num_5class_target_labels(i,KDD_Test_p_num_5class_target(i,42)) = 1;
end

% KDD_Test_mines21
KDD_Test_mines21_num_5class_target_labels = zeros(5,size(KDD_Test_mines21_num_5class_target,1))';
for i=1:size(KDD_Test_mines21_num_5class_target,1)
      % Set targets -> norma:1 and DoS:2 & Probing:3 & R2L:4 & U2R:5
  label = KDD_Test_mines21_txt_5class_target{i};
    switch label
       % DoS
       case {'back', 'land', 'neptune', 'pod', 'smurf', 'teardrop',...
               'apache2', 'mailbomb', 'processtable', 'dosnuke','tcpreset', 'syslogd', 'crashiis', 'arppoison',...
               'udpstorm'}
          KDD_Test_mines21_num_5class_target(i,42) = 2;
        % Probing  
       case {'ipsweep', 'nmap', 'portsweep', 'satan','mscan', 'saint', 'queso',...
               'msscan','ntinfoscan', 'lsdomain', 'illegal_sniffer'}
          KDD_Test_mines21_num_5class_target(i,42) = 3;
        % R2L
        case {'dict', 'netcat', 'sendmail', 'imap', 'ncftp', 'xlock', 'xsnoop', 'sshtrojan',...
                'framespoof', 'ppmacro', 'guest', 'netbus', 'snmpget', 'ftp_write',...
                'phf', 'named','guess_passwd','multihop','spy',...
                'snmpgetattack','snmpguess','warezmaster','warezclient', 'ftpwrite','worm'}
          KDD_Test_mines21_num_5class_target(i,42) = 4;
       % U2R
       case {'buffer_overflow', 'perl', 'loadmodule', 'rootkit',...
                'ps', 'sqlattack', 'xterm','bufferoverflow', ...
               'sechole', 'eject', 'nukepw', 'secret', 'yaga', 'fdformat',...
               'ffbconfig', 'casesen', 'ntfsdos','httptunnel'}
          KDD_Test_mines21_num_5class_target(i,42) = 5;
      % Normal    
       otherwise
          KDD_Test_mines21_num_5class_target(i,42) = 1;
    end
    KDD_Test_mines21_num_5class_target_labels(i,KDD_Test_mines21_num_5class_target(i,42)) = 1;
end
% Twenty_Percent_KDD_Training_p
Twenty_Percent_KDD_Training_p_5class_target_labels = zeros(5,size(Twenty_Percent_KDD_Training_p_num_5class_target,1))';
for i=1:size(Twenty_Percent_KDD_Training_p_num_5class_target,1)
    
% Set targets -> norma:1 and DoS:2 & Probing:3 & R2L:4 & U2R:5
  label = Twenty_Percent_KDD_Training_p_txt_5class_target{i};
    switch label
       % DoS
       case {'back', 'land', 'neptune', 'pod', 'smurf', 'teardrop',...
               'apache2', 'mailbomb', 'processtable', 'dosnuke','tcpreset', 'syslogd', 'crashiis', 'arppoison',...
               'udpstorm'}
          Twenty_Percent_KDD_Training_p_num_5class_target(i,42) = 2;
        % Probing  
       case {'ipsweep', 'nmap', 'portsweep', 'satan','mscan', 'saint', 'queso',...
               'msscan','ntinfoscan', 'lsdomain', 'illegal_sniffer'}
          Twenty_Percent_KDD_Training_p_num_5class_target(i,42) = 3;
        % R2L
        case {'dict', 'netcat', 'sendmail', 'imap', 'ncftp', 'xlock', 'xsnoop', 'sshtrojan',...
                'framespoof', 'ppmacro', 'guest', 'netbus', 'snmpget', 'ftp_write',...
                'phf', 'named','guess_passwd','multihop','spy',...
                'snmpgetattack','snmpguess','warezmaster','warezclient', 'ftpwrite','worm'}
          Twenty_Percent_KDD_Training_p_num_5class_target(i,42) = 4;
       % U2R
       case {'buffer_overflow', 'perl', 'loadmodule', 'rootkit',...
                'ps', 'sqlattack', 'xterm','bufferoverflow', ...
               'sechole', 'eject', 'nukepw', 'secret', 'yaga', 'fdformat',...
               'ffbconfig', 'casesen', 'ntfsdos','httptunnel'}
          Twenty_Percent_KDD_Training_p_num_5class_target(i,42) = 5;
      % Normal    
       otherwise
          Twenty_Percent_KDD_Training_p_num_5class_target(i,42) = 1;
    end
  Twenty_Percent_KDD_Training_p_5class_target_labels(i,Twenty_Percent_KDD_Training_p_num_5class_target(i,42)) = 1;
end

save('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\NSL-KDD Preprocessed_5Class_Target.mat');
% save as xlsx file
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\5 Class Target\NSL-KDD Preprocessed 5 Class Target.xlsx',...
    Twenty_Percent_KDD_Training_p_num_5class_target,'20% KDD Training+');
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\5 Class Target\NSL-KDD Preprocessed 5 Class Target.xlsx',...
    KDD_Training_p_num_5class_target,'KDD Training+');
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\5 Class Target\NSL-KDD Preprocessed 5 Class Target.xlsx',...
    KDD_Test_p_num_5class_target,'KDD Test+');
xlswrite('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\Processd with R\5 Class Target\NSL-KDD Preprocessed 5 Class Target.xlsx',...
    KDD_Test_mines21_num_5class_target,'KDD Test(-21)');



% 
% % Set targets -> norma:1 and DoS:2 & Probing:3 & R2L:4 & U2R:5
%   label = KDD_Training_p_txt_5class_target{i};
%     switch label
%        % DoS
%        case {'back', 'land', 'neptune', 'pod', 'smurf', 'teardrop',...
%                'apache2', 'mailbomb', 'processtable', 'dosnuke','tcpreset', 'syslogd', 'crashiis', 'arppoison',...
%                'udpstorm'}
%           KDD_Training_p_num_5class_target(i,42) = 2;
%         % Probing  
%        case {'ipsweep', 'nmap', 'portsweep', 'satan','mscan', 'saint', 'queso',...
%                'msscan','ntinfoscan', 'lsdomain', 'illegal_sniffer'}
%           KDD_Training_p_num_5class_target(i,42) = 3;
%         % R2L
%         case {'dict', 'netcat', 'sendmail', 'imap', 'ncftp', 'xlock', 'xsnoop', 'sshtrojan',...
%                 'framespoof', 'ppmacro', 'guest', 'netbus', 'snmpget', 'ftp_write',...
%                 'phf', 'named','guess_passwd','multihop','spy',...
%                 'snmpgetattack','snmpguess','warezmaster','warezclient', 'ftpwrite','worm'}
%           KDD_Training_p_num_5class_target(i,42) = 4;
%        % U2R
%        case {'buffer_overflow', 'perl', 'loadmodule', 'rootkit',...
%                 'ps', 'sqlattack', 'xterm','bufferoverflow', ...
%                'sechole', 'eject', 'nukepw', 'secret', 'yaga', 'fdformat',...
%                'ffbconfig', 'casesen', 'ntfsdos','httptunnel'}
%           KDD_Training_p_num_5class_target(i,42) = 5;
%       % Normal    
%        otherwise
%           KDD_Training_p_num_5class_target(i,42) = 1;
%     end
