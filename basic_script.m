subject_list={'4'};
numsubjects = length(subject_list);

for s=1:numsubjects;
subject = subject_list{s};
datafolder = '/Users/agnesgao/Dropbox/UCD/PR_EEG/1_merged/';

%loads dataset
EEG = pop_loadset(['s' subject '_merged.set'],datafolder);

EEG=pop_chanedit(EEG, 'lookup','standard-10-5-cap385.elp');
EEG = pop_saveset( EEG, 'filename',[ 's' subject '_bin.set'],'filepath', '/Users/agnesgao/Dropbox/UCD/PR_EEG/2_chan/');

EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist',...
 ['/Users/agnesgao/Dropbox/UCD/PR_EEG/3_elist/s' subject '_e.txt' ]);
EEG = pop_saveset( EEG, 'filename',[ 's' subject '_bin.set'],'filepath', '/Users/agnesgao/Dropbox/UCD/PR_EEG/3_elist/');

EEG  = pop_binlister( EEG , 'BDF', '/Users/agnesgao/Dropbox/UCD/PR_EEG/pr_bdf_int.txt', 'ExportEL',...
    ['/Users/agnesgao/Dropbox/UCD/PR_EEG/4_bin/s' subject '_bin.txt'],...
 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'Voutput', 'EEG' );

EEG = pop_saveset( EEG, 'filename',[ 's' subject '_bin.set'],'filepath', '/Users/agnesgao/Dropbox/UCD/PR_EEG/4_bin/');

EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); 

EEG = pop_saveset( EEG, 'filename',[ 's' subject '_epoch.set'],'filepath', '/Users/agnesgao/Dropbox/UCD/PR_EEG/5_epoch/');
end



