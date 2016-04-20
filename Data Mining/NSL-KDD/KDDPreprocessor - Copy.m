%%=======================================================================%
% This code read the excel files (KDD feature-based) and do the following:
% 1- calculate the probability for protocol, Service, and flags
% 2- replace nominal values into numeric 
% 3- generate a numeric CSV file 
% 4- read the csv file and normalize it using min-max normalization
% 5- generate a normalized csv file
% This code considers the features as discrete random variable and transfer
% each nominal value by using the probability mass function
%
% created by : Maher Salem - University of Applied Sciences Fulda, Uni Kassel, Germany
%eMail: maher.salem@informatik.hs-fulda.de / maherjas@yahoo.com
%		Date : 10.02.2013
%=========================================================================%

%-----------------------------------------------------------------------%
% The dataset considered in this work has the following header. 
% notice that features are sorted based on column in the datasets, 
% i.e. protocol_type is column one, service is column two etc...
% [ protocol_typ, service, src_byte, wrong_fragment, flag, num_failed_logins, 
% logged_in, root_shell, count, serror_rate, srv_serror_rate, %rerror_rate, 
% srv_rerror_rate, same_srv_rate, diff_srv_rate, dst_host_srv_count, dst_host_serror_rate,class ]
%--------------------------------------------------------------------%

clear all;
clc;
% profile on;
% ticID = tic;
% t = cputime;
matrix_normalized = zeros(); % store the normalized values

%% All files in the directory manually defined :(
excel_file = {'F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx'}; % input excel file
NF = size(excel_file,1); % number of files once more than one

% PDF: Probability density function, the file has replaced the nominal values with numeric
output_pdf = {'PDF_sample.csv'};
        
output_csv = {'NORM_sample.csv'};

% define all protocols to be normalized
protocol_type = {'tcp';'udp';'icmp'}; % you can define more
Nprotocol = size(protocol_type,1); % how many protocols
M = zeros(Nprotocol,1); % save the amount of each protocol
pdf_p = zeros(Nprotocol,1); % save the probability of each protocol

% The Flag in KDD has the following values:
flag = {'SF';'S0';'REJ';'RSTR';'SH';'RSTO';'S1';'RSTOS0';'S3';'S2';'OTH'};
% flag = {'OTH';'REJ';'RSTO';'RSTOS0';'RSTR';'RSTRH';'S0';'S1';'S2';'S3';'SF';'SH';'SHR'};
Nflag = size(flag,1);
F = zeros(Nflag,1);
pdf_f = zeros(Nflag,1);

service = {'ftp_data';'other';'private';'http';'remote_job';...
            'name';'netbios_ns';'eco_i';'mtp';'telnet';'finger';...
            'domain_u';'supdup';'uucp_path';...
            'Z39_50';'smtp';'csnet_ns';'uucp';'netbios_dgm';...
            'urp_i';'auth';'domain';'ftp';'bgp';'ldap';'ecr_i';...
            'gopher';'vmnet';'systat';'http_443';'efs';'whois';...
            'imap4';'iso_tsap';'echo';'klogin';'link';'sunrpc';...
            'login';'kshell';'sql_net';'time';'hostnames';'exec';...
            'ntp_u';'discard';'nntp';'courier';'ctf';'ssh';'daytime';...
            'shell';'netstat';'pop_3';'nnsp';'IRC';'pop_2';'printer';...
            'tim_i';'pm_dump';'red_i';'netbios_ssn';'rje';'X11';'urh_i';...
            'http_8001';'aol';'http_2784';'tftp_u';'harvest'};
% service = {'aol'; 'http_443'; 'http_8001'; 'http_2784';...
%            'domain_u'; 'ftp_data'; 'auth'; 'bgp'; 'courier';...
%            'tftp_u'; 'uucp_path'; 'csnet_ns'; 'ctf';...
%            'daytime';'time'; 'discard'; 'domain'; 'echo';...
%            'eco_i'; 'ecr_i'; 'efs'; 'exec'; 'finger'; 'gopher';...
%            'harvest'; 'hostnames'; 'http'; 'imap4'; 'IRC';...
%            'iso_tsap'; 'klogin'; 'kshell'; 'ldap'; 'link';...
%            'login'; 'smtp'; 'mtp'; 'name';...
%            'netbios_dgm'; 'netbios_ns'; 'netbios_ssn'; 'netstat';...
%            'nnsp'; 'nntp'; 'ntp_u'; 'other'; 'pm_dump'; 'pop_2';...
%            'pop_3'; 'printer'; 'private'; 'red_i'; 'remote_job'; ...
%            'rje'; 'shell'; 'sql_net'; 'ssh'; 'sunrpc';...
%            'supdup'; 'systat'; 'telnet'; 'tim_i';...
%            'urh_i'; 'urp_i'; 'uucp';'ftp'; 'vmnet';...
%            'whois'; 'X11'; 'Z39_50'};
       %Z39_50,X11,Whois,vmnet,uucp_path,uucp,urp_i,urh_i,
       %time,tim_i,tftp_u,telnet,systat,supdup,sunrpc,ssh,
       %sql_net,smtp,shell,rje,remote_job,red_i,private,
       %printer,pop_3,pop_2,pm_dump,other,ntp_u,nntp,nnsp,
       %netstat,netbios_ssn,netbios_ns,netbios_dgm,name,mtp,
       %login,link,ldap,kshell,klogin,iso_tsap,IRC,imap4,http_8001,
       %http_443,http_2784,http,hostnames,harvest,gopher,ftp_data,
       %ftp,finger,exec,efs,ecr_i,eco_i,echo,domain_u,domain,discard,
       %daytime,ctf,csnet_ns,courier,bgp,auth,aol
Nservice = size(service,1); % return number of services
N = zeros(Nservice,1); % create a zeros arry with one column only
pdf_s = zeros(Nservice,1);

%===================== Load the Dataset from xls File ===================%

for f=1:NF
% read everything into one cell array
fprintf('Start processing the File : %s', excel_file{f});fprintf('\n');
[~,~,raw] = xlsread(excel_file{f});
%Read first sheet or KDD Training+ from NSL-KDD Dataset.xlsx 
% [~,~,raw] = xlsread('F:\Documents\MATLAB\Data\KDD\NSL-KDD Dataset\NSL-KDD Dataset.xlsx',...
%     'KDD Training+');

% find numbers
containsNumbers = cellfun(@isnumeric,raw);
% convert to string
raw(containsNumbers) = cellfun(@num2str,raw(containsNumbers),'UniformOutput',false);
row_count = size(raw,1);   % how many rows
col_count = size(raw,2);   % how many nominal columns

%unfortunately you have to determin each nominal column manually
proto_col = raw(:,2); % determine protocol type column
flag_col = raw(:,4); % determine flag column 
service_col = raw(:,3); %Service column

% calculate the probabilities of the protocol type
for i=1:Nprotocol
        M(i) = sum(strcmp(protocol_type(i),proto_col));
        pdf_p(i) = M(i)/row_count;
end

%% replace all probability values for protocol type nominal --> numeric
for p = 1:length(protocol_type)
proto_col = strrep(proto_col,protocol_type{p},num2str(pdf_p(p)));
end
 
%claculate probabilities of flag     
for i=1:Nflag
        F(i) = sum(strcmp(flag(i),flag_col));
        pdf_f(i) = F(i)/row_count;
end

% replace probabilities of flag nominal --> numeric
for fg = 1:length(flag)
flag_col = strrep(flag_col,flag{fg},num2str(pdf_f(fg)));
end

%====== Service column calculation and replacement
for i=1:Nservice
        N(i) = sum(strcmp(service(i),service_col));
        pdf_s(i) = N(i)/row_count;
end

%% replace all probability values for protocol type nominal --> numeric
for s = 1:length(service)
service_col = strrep(service_col,service{s},num2str(pdf_s(s)));
end
% Set all values back to the main cell matrix file
raw(:,2) = proto_col;
raw(:,4) = flag_col;
raw(:,3) = service_col;

%====== read the PDF file to start normalization
fid=fopen(output_pdf{f},'wt');
   for i=1:row_count
     fprintf(fid,'%s,',raw{i,1:end-1});
     fprintf(fid,'%s\n',raw{i,end});
   end
   fclose(fid);
fprintf('-->  Currently generated is : %s',output_pdf{f});fprintf('\n');

%===================== End Converting ===============================%

end

%%=================== Start Normalization ===========================%

for f=1:NF
%===================== Load the Dataset from xls File ===================%
%data = xlsread ('PDF_most_valuable_and_relevant_features.xlsx');
% data = load (output_pdf{f}); % remove all headers, if headers are available then use [text,data]=load....
data = raw; 
row_count = size(data,1);   % how many rows
col_count = size(data,2)-1;   % how many columns
%=========================================================================%

raw_matrix = data;

%loops to select each feature and normalize it individually
for i=1:col_count
    
    selected_column = raw_matrix(:,i);
    maximum = max(selected_column);
    minimum = min(selected_column);
    if maximum > 1
	    for j=1:size(selected_column,1)
		    if selected_column(j) == 0
            matrix_normalized(j,i) = 0;
			else
            matrix_normalized(j,i) = (selected_column(j)-minimum) / (maximum - minimum);
			end
		end
	else
		for j=1:size(selected_column,1)
		    matrix_normalized(j,i) = selected_column(j); % do not normalize and save the values directly
		end
	end	
end

%   % write to a csv file 
csvwrite(output_csv{f},matrix_normalized); % output file

fprintf('==> Finished is: %s',output_csv{f});fprintf('\n');

end
%==================== End Normalizing =================================%

% fprintf('Total execution time is: %f \n', cputime-t);
% fclose all;
% clear;