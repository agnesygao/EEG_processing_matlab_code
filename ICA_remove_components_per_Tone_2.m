subject_list= {'101','102','103','104','105','106','107','108','109','110','111','112','113','114','115','116','117','118','119','120'};
parentfolder = '\\atlas-rstor01.ad.uillinois.edu\research\ELPLab\Experiments\Tone\EEG\';
subjectfolder = [parentfolder '\ICA_weights\'];
numbsubject  = length(subject_list);

%The problem we had with ICA was that it counted rejections twice,
%sometimes putting us in the negative. The script below fixes it. Read
%through it. After the "business as usual section", cpoy/paste your normal
%processing script. For the first section, if you need to interpolate or
%resample, add those as necessary. Pay attention to all the filepaths so
%that it works for you. 

%First, reprocess the participant from scratch using the epochs that you
%want. This includes: loading the data set, resampling if you need to,
%interpolating if you need to, filtering, creating an event list, listing
%bins, and epoching. This coding doesn't include interpolation or
%resampling, so use your own codes for that.

%NOTE: You do NOT edit the channels yet.

%This code contains an if/else statement. Add a new else if and
%remove_components line for each subject in your subject_list (up top).
%This way, there will be different components removed from each subject.
%I've done two example below. Add your subject/remove_components line ABOVE
%the "end" line so that it can be parsed. Otherwise, MATLab will scream at
%you. 
for s=1:numbsubject 
    subject = subject_list{s}; 
    fprintf('\n\n\n*** Processing subject %d (%s) ***\n\n\n', s, subject);

if subject == '101';
    remove_components = [1 10];
elseif subject=='102';
    remove_components = [1 5];
elseif subject=='103';
    remove_components = [1 2];
elseif subject=='104';
    remove_components = [1 2 3 4 5 6 15];
elseif subject=='105';
    remove_components = [1 3];
elseif subject=='106';
    remove_components = [1 15];
elseif subject=='107';
    remove_components = [3 7];
elseif subject=='108';
    remove_components = [1 3 4];
elseif subject=='109';
    remove_components = [1];
elseif subject=='110';
    remove_components = [1 4];
elseif subject=='111';
    remove_components = [1 2 4 5 6 9];
elseif subject=='112';
    remove_components = [1 3];
elseif subject=='113';
    remove_components = [11 14];
elseif subject=='114';
    remove_components = [1 3 12];
elseif subject=='115';
    remove_components = [1 3 13]; 
elseif subject=='116';
    remove_components = [7 25];
elseif subject=='117';
    remove_components = [1 2 16];
elseif subject=='118';
    remove_components = [1 3];
elseif subject=='119';
    remove_components = [1 4];
elseif subject=='120';
    remove_components = [1 5];

end
EEG = pop_loadbv([parentfolder] , ['Tone_' subject '.vhdr']);

 EEG  = pop_basicfilter( EEG,  1:32 , 'Boundary', 'boundary', 'Cutoff',  [0.1 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  4,...
    'RemoveDC', 'on' );

EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 },...
    'BoundaryString', { 'boundary' }, 'Eventlist', [parentfolder '\Eventlist\' subject '_event.txt']);  

EEG  = pop_binlister( EEG , 'BDF', [ parentfolder 'bin_tone.txt'], 'ExportEL',...
    [parentfolder '\Eventlist\' subject '_event_bins.txt'],...
    'IndexEL', 1 , 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' ); 

EEG = pop_epochbin( EEG , [-200.0  801.0],  'pre'); 

%Now we're going to load the ICA set to load the components and clean the
%data. We make a new variable called EEGICA. It's big, so we're going to
%delete it soon to avoid mistakes. 
EEGICA = pop_loadset('filename', [subject '_ICAweights.set'], 'filepath' ,[ parentfolder '\ICA_weights\']);

%These set the parameters of EEG (original data) to mirror EEGICA (the ICA
%dataset). We need this. 
EEG.icawinv = EEGICA.icawinv;
EEG.icasphere = EEGICA.icasphere;
EEG.icaweights = EEGICA.icaweights;
EEG.icachansind = EEGICA.icachansind;

%Clear EEGICA because it's big and ugly. 
clear EEGICA;

%Will promp you if you have a problem. SUPER important
EEG = eeg_checkset(EEG);

% Now here you list what components are to be removed. This is set up top. 
%Modify this for each participant
EEG = pop_subcomp( EEG, remove_components, 0);

%This is here twice because it's stupid important
EEG = eeg_checkset(EEG);

%Now back to business as usual. Modify this for your experiment
  EEG = pop_eegchanoperator( EEG, {  'nch1 = ch1 - ( .5*ch32 ) Label FP1',  'nch2 = ch2 - ( .5*ch32 ) Label FP2',  'nch3 = ch3 - ( .5*ch32 ) Label F7',...
  'nch4 = ch4 - ( .5*ch32 ) Label F3',  'nch5 = ch5 - ( .5*ch32 ) Label Fz',  'nch6 = ch6 - ( .5*ch32 ) Label F4',...
  'nch7 = ch7 - ( .5*ch32 ) Label F8',  'nch8 = ch8 - ( .5*ch32 ) Label FC5',  'nch9 = ch9 - ( .5*ch32 ) Label FC1',  'nch10 = ch10 - ( .5*ch32 ) Label FC2',...
  'nch11 = ch11 - ( .5*ch32 ) Label FC6',  'nch12 = ch12 - ( .5*ch32 ) Label T7',  'nch13 = ch13 - ( .5*ch32 ) Label C3',...
  'nch14 = ch14 - ( .5*ch32 ) Label Cz',  'nch15 = ch15 - ( .5*ch32 ) Label C4',  'nch16 = ch16 - ( .5*ch32 ) Label T8',  'nch17 = ch17 - ( .5*ch32 ) Label CP5',...
  'nch18 = ch18 - ( .5*ch32 ) Label CP1',  'nch19 = ch19 - ( .5*ch32 ) Label CP2',  'nch20 = ch20 - ( .5*ch32 ) Label CP6',...
  'nch21 = ch21 - ( .5*ch32 ) Label P7',  'nch22 = ch22 - ( .5*ch32 ) Label P3',  'nch23 = ch23 - ( .5*ch32 ) Label Pz',  'nch24 = ch24 - ( .5*ch32 ) Label P4',...
  'nch25 = ch25 - ( .5*ch32 ) Label P8',  'nch26 = ch26 - ( .5*ch32 ) Label O1',  'nch27 = ch27 - ( .5*ch32 ) Label Oz',...
  'nch28 = ch28 - ( .5*ch32 ) Label O2',  'nch29 = ch29 - ( .5*ch32 ) Label LO1',  'nch30 = ch30 - ( .5*ch32 ) Label LO2',  'nch31 = ch31 - ( .5*ch32 ) Label IO1',...
  'nch32 = ch32 - ( .5*ch32 ) Label M2',  'nch33 = ch31 - ch1 Label VEOG',  'nch34 = ch30-ch29 Label HEOG'} , 'ErrorMsg',...
 'popup' );

%Lookup channel locations in *this* filepath
   EEG=pop_chanedit(EEG, 'lookup','standard-10-5-cap385.elp');
   
%Artfiact detection and removal
 EEG  = pop_artmwppth( EEG , 'Channel', [ 33 34], 'Flag',  1 , 'Threshold',  60, 'Twindow', [ -200 801],...
    'Windowsize',  200, 'Windowstep',  100 ); 

 EEG  = pop_artextval( EEG , 'Channel',  1:32, 'Flag',  1 , 'Threshold', [ -100 100], 'Twindow', [ -200 801] );

 EEG = pop_summary_AR_eeg_detection(EEG, [ parentfolder '\ARfiles_ICAed\' subject '_ar.txt']);

% %save the set in the filepath 
    EEG = pop_saveset( EEG, 'filename',[subject '_ardata.set'],'filepath',[ parentfolder '\\ARdata_ICAed\\']);
    
    % Average all 'good' trials, excluding any boundary events, 
    ALLERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex', 1 , 'ExcludeBoundary', 'on', 'SEM', 'on' );
     
    %save the ERP
    ALLERP = pop_savemyerp(ALLERP, 'erpname', [subject '_ERP'], 'filename', [ subject '_ERP.erp'], 'filepath',...
    [ parentfolder '\\ERP_Final\\'], 'Warning', 'off');    
end;