subject_list={'1','2','3','5','7','8','9','10','11','12','13','14','15'};
numsubjects = length(subject_list);

for s=1:numsubjects;
subject = subject_list{s};
datafolder = '/Users/agnesgao/Dropbox/UCD/PR_EEG/8_erp/';


[ERP ALLERP] = pop_loaderp( 'filename', ['s' subject '_erp.erp'], 'filepath',datafolder);

ERP = pop_gaverager(datafolder, 'ExcludeNullBin', 'on', 'SEM', 'on' );

ERP = pop_savemyerp(ERP, 'erpname', 'GA',...
    'filename', 'GA.erp', 'filepath', datafolder, 'Warning', 'off');
end
