:- use_module(library(odbc)).

open :- odbc_connect('prologdb', _, [alias(db)]).
close :- odbc_disconnect(db).

test :-
    %this works btw, change the rest of your code with too much select statements into this later.
    open,
    writeln('ID   Name   Email   Phone   Address   Type   Model   Duration   RentStart   RentEnd   SalesDate'),
    concat_atom(["SELECT rental_id, customer_name, customer_email, customer_phone, customer_address, vehicle_type, model, rental_duration, rental_start_date, rental_end_date, transaction_date FROM transaction_info_complete WHERE customer_name LIKE '%Sam%'"], SQL),
    findall([ID, Name, Email, Phone, Address, Type, Model, Duration, RentStart, RentEnd, SalesDate], odbc_query(db, SQL, row(ID, Name, Email, Phone, Address, Type, Model, Duration, RentStart, RentEnd, SalesDate)), Rows),
    close,
    process_rows(Rows).

test2 :-
    writeln("Input the rental start date (YYYY-MM-DD)"),
    read_line_to_codes(user_input, Codes),
    atom_codes(Date, Codes),
    writeln(Date). 

test3 :-
    %this works btw, change the rest of your code with too much select statements into this later.
    read_line_to_codes(user_input, Codes),
    atom_codes(Date, Codes),
    testinput(Date).

testinput(Input) :-
        
    
        open,
        writeln('ID   Name   Email   Phone   Address   Type   Model   Duration   RentStart   RentEnd   SalesDate'),
        concat_atom(["SELECT rental_id, customer_name, customer_email, customer_phone, customer_address, vehicle_type, model, rental_duration, rental_start_date, rental_end_date, transaction_date FROM transaction_info_complete WHERE customer_name LIKE '%",Input,"%'"], SQL),
        findall([ID, Name, Email, Phone, Address, Type, Model, Duration, RentStart, RentEnd, SalesDate], odbc_query(db, SQL, row(ID, Name, Email, Phone, Address, Type, Model, Duration, RentStart, RentEnd, SalesDate)), Rows),
        close,
        process_rows(Rows).
    


% Input Reader
read_user_choice(Choice) :-
    write('Enter input: '),
    read(Choice).

read_userinput(Input) :-
    read_line_to_codes(user_input, InputCodes),
    atom_codes(Input, InputCodes).

% GUI
start :-
    writeln("Welcome to Prolog Vehicle Rental System! Please Choose Below!"),
    writeln('1. Rental Entries'),
    writeln('2. Vehicles'),
    writeln('3. Exit'),
    read_user_choice(Choice),
    start_choice(Choice),
    Choice == 3, !.


start_choice(1) :-
    writeln('All inputs must not start with a capital letter.'),
    repeat,
    writeln('1. Make a Rental Entry'),
    writeln('2. List Rental Entries'),
    writeln('3. Update Rental Entries'),
    writeln('4. Delete Rental Entries'),
    writeln('5. Exit'),
    read_user_choice(Choice),
    handle_choice(Choice),
    Choice == 5, !.

start_choice(2) :-
    writeln('All inputs must not start with a capital letter.'),
    repeat,
    writeln('1. Add Vehicles'),
    writeln('2. List Vehicles'),
    writeln('3. Update Vehicles'),
    writeln('4. Delete Vehicles'),
    writeln('5. Exit'),
    read_user_choice(Choice),
    vehicle_choice(Choice),
    Choice == 5, !.

start_choice(3) :-
    writeln('Exiting...').


% Create Rental Entries
handle_choice(1) :-
    writeln('Please input if whether the customer is a new customer or an existing customer.'),
    writeln('1. New Customer'),
    writeln('2. Existing Customer'),
    read_user_choice(Choice),
    getCustomerInfo(Choice),
    writeln('Input the Customer ID'),
    read_user_choice(CusID),
    writeln('Input the Vehicle ID'),
    read_user_choice(VID),
    writeln('Input rental duration'),
    read_user_choice(Duration),
    read_line_to_codes(user_input, _), 
    writeln("Input the rental start date (YYYY-MM-DD)"),
    read_userinput(Date),
    addRental(CusID, VID, Duration, Date),
    nl.

% List Rental Entries
handle_choice(2) :-
    writeln('You selected Option 2!'),
    writeln('1. List all rental entries'),
    writeln('2. List all rental entries by name'),
    read_user_choice(Choice),
    getRental(Choice),
    nl.

% Update Rental Entries
handle_choice(3) :-
    writeln('You selected Option 3!'),
    writeln('Input the ID of the rental entry you want to update.'),
    read_user_choice(ID),
    writeln('Input the data that you want to update.'),
    writeln('customer_id'),
    writeln('vehicle_id'),
    writeln('rental_duration'),
    writeln('rental_start_date'),
    read_user_choice(Column),
    writeln("Input the new value. (For date, format is YYYY-MM-DD)"),
    read_user_choice(Value),
    updateRental(ID, Column, Value),
    nl.

% Delete Rental Entries
handle_choice(4) :-
    writeln('You selected Option 4!'),
    writeln('Input the ID of the vehicle you want to delete.'),
    read_user_choice(Input),
    deleteRental(Input),
    nl.

handle_choice(5) :-
    writeln('Exiting...').

% Vehicle Create
vehicle_choice(1) :-
    writeln('You selected Option 1!'),
    writeln('Input the number of the vehicle type.'),
    writeln('1. Van'),
    writeln('2. Truck'),
    writeln('3. Motorcycle'),
    read_user_choice(Type),
    writeln('Input the model of this vehicle'),
    read_user_choice(Model),
    addVehicle(Type, Model),  % Add these lines to print values
    nl.

% Vehicle Read
vehicle_choice(2) :-
    writeln('You selected Option 2!'),
    writeln('1. List all vehicles'),
    writeln('2. List vehicles by type'),
    read_user_choice(Choice),
    selectVehicleInfo(Choice),
    nl.

% Vehicle Update
vehicle_choice(3) :-
    writeln('You selected Option 3!'),
    writeln('Input the ID of the vehicle you want to update.'),
    read_user_choice(ID),
    writeln('Input the data that you want to update.'),
    writeln('vehicle_type'),
    writeln('model'),
    writeln('rental_status'),
    read_user_choice(Column),
    writeln('Input the new value.'),
    read_user_choice(Value),
    updateVehicle(ID, Column, Value),
    nl.

% Vehicle Delete
vehicle_choice(4) :-
    writeln('You selected Option 4!'),
    writeln('Input the ID of the vehicle you want to delete.'),
    read_user_choice(Input),
    deleteVehicle(Input),
    nl.

vehicle_choice(5) :-
    writeln('Exiting...').

addVehicle(Type, Model) :-
    open,
    concat_atom(['INSERT INTO tbl_vehicles (vehicle_type, model, rental_status) VALUES (\'', Type, '\', \'', Model, '\', 2)'], SQL1),
    odbc_query(db, SQL1),
    close.

updateVehicle(ID, Column, Value) :-
    open,
    atomic_list_concat(['UPDATE tbl_vehicles SET ', Column, ' = ', Value, ' WHERE vehicle_id = ', ID], SQL1),
    odbc_query(db, SQL1),
    close.

updateVehicleStatusRented(ID) :-
    open,
    atomic_list_concat(['UPDATE tbl_vehicles SET rental_status = 1 WHERE vehicle_id = ', ID], SQL1),
    odbc_query(db, SQL1),
    close.

deleteVehicle(ID) :-
    open,
    atomic_list_concat(['DELETE FROM tbl_vehicles WHERE vehicle_id = ', ID], SQL1),
    odbc_query(db, SQL1),
    close.

selectVehicleInfo(1) :- 
    open,
    write('ID'), write('   '),write('Type'), write('   '), write('Model'), write('   '), writeln('Status'),
    concat_atom(["SELECT vehicle_id, vtype_name,model,rstatus_name FROM vehicles_info"], SQL),
    findall([ID, Type, Model, Status], odbc_query(db, SQL, row(ID, Type, Model, Status)), Rows),
    
    close,
    process_rows4(Rows).

selectVehicleInfo(2) :- 
    writeln("Input the type."),
    read_user_choice(Choice),
    selectVehicleInfoByType(Choice).

selectVehicleInfoByType(Type) :-
    open,
    write('ID'), write('   '),write('Type'), write('   '), write('Model'), write('   '), writeln('Status'),
    
    concat_atom(["SELECT vehicle_id FROM vehicles_info WHERE vtype_name = '", Type, "'"], SQL1),
    concat_atom(["SELECT vtype_name FROM vehicles_info WHERE vtype_name = '", Type, "'"], SQL2),
    concat_atom(["SELECT model FROM vehicles_info WHERE vtype_name = '", Type, "'"], SQL3),
    concat_atom(["SELECT rstatus_name FROM vehicles_info WHERE vtype_name = '", Type, "'"], SQL4),

    findall(P, odbc_query(db, SQL1, row(P)), Rows),
    findall(P, odbc_query(db, SQL2, row(P)), Rows2),
    findall(P, odbc_query(db, SQL3, row(P)), Rows3),
    findall(P, odbc_query(db, SQL4, row(P)), Rows4),
    
    close,
    process_rows(Rows, Rows2, Rows3, Rows4).   


getCustomerInfo(1) :-
    writeln('Please input customer details below!'),
    read_line_to_codes(user_input, _),
    writeln('What is the customer\'s fullname?'),
    read_userinput(Name),
            
    writeln('What is the customer\'s email address?'),
    read_userinput(Email),
            
    writeln('What is the customer\'s phone no.?'),
    read_user_choice(Phone),
    read_line_to_codes(user_input, _), 
    
    writeln('What is the customer\'s current address?'),
    read_userinput(Add),
            
    addCustomer(Name, Email, Phone, Add),
    writeln('This is the customer\'s info and customerID!'),
    getCustomer(Name).
    
getCustomerInfo(2) :-
    writeln('Please input customer name below!'),
    read_line_to_codes(user_input, _),
    writeln('What is the customer\'s fullname?'),
    read_userinput(Name),
    getCustomer(Name).
        
    
addCustomer(Name, Email, Phone, Add) :-
    open,
    concat_atom(['INSERT INTO tbl_customers (customer_name, customer_email, customer_phone, customer_address) VALUES (\'', Name, '\', \'', Email, '\', ', Phone, ', \'', Add, '\');'], SQL1),
    odbc_query(db, SQL1),
    close.

getCustomer(Name) :-
    open,
    writeln("Here is the customer's ID and information."),
    write('ID'), write('   '),write('Name'), write('   '), write('Email'), write('   '), writeln('Phone'),
    concat_atom(["SELECT customer_id FROM tbl_customers WHERE customer_name LIKE '%", Name, "%'"], SQL1),
    concat_atom(["SELECT customer_name FROM tbl_customers WHERE customer_name LIKE '%", Name, "%'"], SQL2),
    concat_atom(["SELECT customer_email FROM tbl_customers WHERE customer_name LIKE '%", Name, "%'"], SQL3),
    concat_atom(["SELECT customer_phone FROM tbl_customers WHERE customer_name LIKE '%", Name, "%'"], SQL4),

    findall(P, odbc_query(db, SQL1, row(P)), Rows),
    findall(P, odbc_query(db, SQL2, row(P)), Rows2),
    findall(P, odbc_query(db, SQL3, row(P)), Rows3),
    findall(P, odbc_query(db, SQL4, row(P)), Rows4),
    
    close,
    process_rows(Rows, Rows2, Rows3, Rows4).    

addRental(CusID,VID,Duration,Date) :-
    open,
    concat_atom(['INSERT INTO tbl_transaction (customer_id, vehicle_id, rental_duration, rental_start_date, transaction_date) VALUES (\'', CusID, '\', \'', VID, '\', ', Duration, ', \'', Date, '\', CAST(GETDATE() AS DATE));'], SQL1),
    odbc_query(db, SQL1),
    close,
    updateVehicleStatusRented(VID).

getRental(1) :-
    open,
    write('ID'), write('   '),write('Name'), write('   '), write('Email'), write('   '), write('Phone'),  write('   '), write('Address'),  write('   '), write('Type'),  write('   '), write('Model'),  write('   '), write('Duration'),  write('   '), write('RentStart'),  write('   '), write('RentEnd'), write('   '), writeln('SalesDate'),
    concat_atom(["SELECT rental_id, customer_name, customer_email, customer_phone, customer_address, vehicle_type, model, rental_duration, rental_start_date, rental_end_date, transaction_date FROM transaction_info_complete"], SQL),
    findall([ID, Name, Email, Phone, Address, Type, Model, Duration, RentStart, RentEnd, SalesDate], odbc_query(db, SQL, row(ID, Name, Email, Phone, Address, Type, Model, Duration, RentStart, RentEnd, SalesDate)), Rows),
    close,
    process_rows(Rows).

getRental(2) :-
    writeln("Input the Name."),
    read_line_to_codes(user_input, _),
    read_userinput(Name),
    getRentalByName(Name).

getRentalByName(Input) :-
    open,
    write('ID'), write('   '),write('Name'), write('   '), write('Email'), write('   '), write('Phone'),  write('   '), write('Address'),  write('   '), write('Type'),  write('   '), write('Model'),  write('   '), write('Duration'),  write('   '), write('RentStart'),  write('   '), write('RentEnd'), write('   '), writeln('SalesDate'),
    concat_atom(["SELECT rental_id, customer_name, customer_email, customer_phone, customer_address, vehicle_type, model, rental_duration, rental_start_date, rental_end_date, transaction_date FROM transaction_info_complete WHERE customer_name LIKE '%",Input,"%'"], SQL),
    findall([ID, Name, Email, Phone, Address, Type, Model, Duration, RentStart, RentEnd, SalesDate], odbc_query(db, SQL, row(ID, Name, Email, Phone, Address, Type, Model, Duration, RentStart, RentEnd, SalesDate)), Rows),
    close,
    process_rows(Rows).

updateRental(ID, Column, Value) :-
    open,
    atomic_list_concat(['UPDATE tbl_transaction SET ', Column, ' = ', Value, ' WHERE rental_id = ', ID], SQL1),
    odbc_query(db, SQL1),
    close,
    writeln("Values updated.").

deleteRental(ID) :-
    open,
    atomic_list_concat(['DELETE FROM tbl_transaction WHERE rental_id = ', ID], SQL1),
    odbc_query(db, SQL1),
    close.

process_rows([]).
process_rows([Row|Rest]) :-
    format("~w   ~w   ~w   ~w   ~w   ~w   ~w   ~w   ~w   ~w   ~w~n", Row),
    process_rows(Rest).

process_rows4([Row|Rest]) :-
    format("~w   ~w   ~w   ~w~n", Row),
    process_rows4(Rest).

process_rows([], [], [], []).
process_rows([Row|Rest],[Row2|Rest2], [Row3|Rest3], [Row4|Rest4]) :-
    write(Row), write('   '), write(Row2), write('   '), write(Row3),write('   '), writeln(Row4),
    process_rows(Rest, Rest2, Rest3, Rest4).