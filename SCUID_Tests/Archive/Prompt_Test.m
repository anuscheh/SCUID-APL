%% Prompt testing
%% Asking User to give extra information
disp("Now I'd like to request some basic information about this log.")
test_date = input("When was this test conducted? [YYYY-MM-DD]: ","s");
chip_name = input("Which sensor chip is installed? [e.g. AMES5]: ","s");
test_description = input(sprintf("Please give a bried description to this test:\n"),"s");
% Event addition
fprintf("\nNow it's time to input the events of this test.\n")
fprintf("Please reading the following instructions CAREFULLY!\n")
fprintf("\x2022 You will be asked to first determine an event type. You can pick from a \n" + ...
        "  list of options, or you can choose OTHER to type in your own.\n")
fprintf("\x2022 Then, you type in the time of this event in terms of time stamps recorded \n" + ...
        "  in lab notes.\n")
fprintf("\x2022 Then, you add your extra comments to this event. Try to keep it brief, as \n" + ...
        "  this will be shown next to the verticle line marker on the plots. Longer \n" + ...
        "  descriptions might not be shown properly.\n")
fprintf("\x2022 At the end, you will be asked if you want to enter another event.\n")
input("Now press any key to start adding events... \n")
event_counter = 0;
add_event_done = false;
events = string.empty();
event_times = string.empty();
while ~add_event_done
    add_event = input("Add a new event? [Y/n]: ","s");
    if strcmpi(add_event, "Y") || isempty(add_event)
        fprintf("What is Event #%i?\n",event_counter+1)
        PrintEvenChoices();
        event_type = input("Please choose an option: ","s");
        switch event_type
            case '0'
                other_event = input("Please input custom event type: ","s");
                fprintf("You have typed in: %s.\n",other_event);
                event_name = other_event;
                event_counter = event_counter+1;
                event_time = input("When did this event happen? [HH:MM:SS]: ","s");
            case '1'
                disp("You have chosen: B.")
                event_name = "B";
                event_counter = event_counter+1;
                event_time = input("When did this event happen? [HH:MM:SS]: ","s");
            case '2'
                disp("You have chosen: M.")
                event_name = "M";
                event_counter = event_counter+1;
                event_time = input("When did this event happen? [HH:MM:SS]: ","s");
            case '3'
                disp("You have chosen: B + M.")
                event_name = "B+M";
                event_counter = event_counter+1;
                event_time = input("When did this event happen? [HH:MM:SS]: ","s");
            case 'x'
                disp("OK, aborted!")
                continue
        end
        events = [events event_name];
        event_times = [event_times event_time];
    elseif strcmpi(add_event, "n")
        add_event_done = true;
        fprintf("OK! Finished event addtion. You added %i events in total.\n", event_counter)
    end
end
if length(event_times) ~= length(events)
    disp("Error: lengths of events and timestamps not matching!")
    return
end
% Process event times into proper format
for i=1:length(event_times)
    event_times(i) = strcat(test_date, " ", event_times(i));
end


%% Funtions
function printed = PrintEvenChoices(~)
    fprintf("[1] Changing 3-way valve position to B only\n")
    fprintf("[2] Changing 3-way valve position to M only\n")
    fprintf("[3] Changing 3-way valve position to B + M \n")
    fprintf("[0] Input your own\n")
    fprintf("[x] Abort \n")
    printed = true;
end