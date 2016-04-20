%% KDDPreprocessor
function [processed_dataset] = Nominal2Numeric(dataset)
	

%%=======================================================================%
% I use this code for preprocessing, but i changh the code for my application
% This code read the raw data(cell format) (KDD feature-based) and do the following:
% 1- calculate the probability for protocol, Service, and flags
% 2- replace nominal values into numeric 
% 3- generate a numeric file 
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
%--------------------------------------------------------------------%

% PDF: Probability density function, the file has replaced the nominal values with numeric

% define all protocols to be normalized
protocol_type = {'tcp';'udp';'icmp'}; % you can define more
Nprotocol = size(protocol_type,1); % how many protocols
M = zeros(Nprotocol,1); % save the amount of each protocol
pdf_p = zeros(Nprotocol,1); % save the probability of each protocol

% The Flag in KDD has the following values:
flag = {'SF';'S0';'REJ';'RSTR';'SH';'RSTO';'S1';'RSTOS0';'S3';'S2';'OTH'};
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

Nservice = size(service,1); % return number of services
N = zeros(Nservice,1); % create a zeros arry with one column only
pdf_s = zeros(Nservice,1);

%===================== Read the Data from dataset ===================%
raw = dataset;

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
%===================== End Converting ===============================%
processed_dataset = raw;

end