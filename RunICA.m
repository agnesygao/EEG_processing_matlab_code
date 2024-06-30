subject_list = {'4'};
numsubjects = length(subject_list);
datafolder = '/Users/agnesgao/Dropbox/UCD/PR_EEG/5_epoch/';

for s=1:numsubjects
    subject = subject_list{s};

EEG = pop_loadset('filename',['s' subject '_epoch.set'],'filepath',[datafolder]);
EEG = pop_runica(EEG, 'chanind', [1:33], 'stop', 1E-9);
EEG = pop_saveset( EEG, 'filename',[subject '_ICA.set'],'filepath',['/Users/agnesgao/Dropbox/UCD/PR_EEG/6_ICA_weights/']);
end
