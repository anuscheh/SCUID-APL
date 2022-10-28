clear; close all; clc;
% Loading data set
load('CNT_Results_NO.mat')
last_entry = length(CNT_Results_NO);

% loading/creating cheatsheet

% Finding first actual data entry
for i=1:last_entry
    if ~isempty(CNT_Results_NO(i,1).chip)
        first_entry = i;
        break
    end
end

EntryNumber = (first_entry:last_entry)';
ChipNumber = vertcat(CNT_Results_NO.chip);
EntryDate = datetime(vertcat(CNT_Results_NO.testdateM),"ConvertFrom","datenum");

%% 
addinfo = vertcat(CNT_Results_NO.addinfo);

%% 
AddedHumidity = strings(size(EntryNumber));
for i=1:length(AddedHumidity)
    if contains(addinfo(i), 'RH','IgnoreCase',true)
        hasRH = 'Yes';
    else
        hasRH = 'No';
    end
    AddedHumidity(i,1) = hasRH;
end

%% Test Comments
TestComments = addinfo;

%% Extra Comments
ExtraComments = strings(size(TestComments));
%% Board Number
% BoardNumber = zeros(size(EntryNumber));
% for i=1:length(BoardNumber)
%     b_num = extractAfter(addinfo(i),"Board");
%     b_num = char(b_num);
%     BoardNumber(i,1) = str2double(b_num(1));
% end

%% Write to table
% Make newest table
NewTable = table(EntryNumber,AddedHumidity,ChipNumber,EntryDate,TestComments,ExtraComments);
% Append newly added entries to the old sheet
cheatsheet = "MFC_Tests_Cheatsheet.xlsx";
if isfile(cheatsheet)
    % First, read existing table and find the index of last entry
    CheatTable = readtable(cheatsheet);
    last_index = length(CheatTable.EntryNumber);
    % Then, in the new table, find the index of that last EntryNumber
    if length(NewTable.EntryNumber) > last_index
        EntriesToAppend = NewTable(last_index+1:end,:);
        disp("These are the newly added entries this time.")
        disp(EntriesToAppend)
        CheatTable = [CheatTable; EntriesToAppend];
        writetable(CheatTable,cheatsheet,"WriteMode","replacefile")
        fprintf("New entries has been appended to: %s\n", cheatsheet)
    else
        disp("No new entries to add.")
    end
else
    disp("Cheatsheet not created yet. I will create it now.")
    writetable(NewTable,cheatsheet)
    fprintf("The following Cheatsheet has been created: %s\n", cheatsheet)
end 