source("Libraries.R")

listOfVars <- ls()
if(!(   'DB_USERNAME' %in% listOfVars &&
        'DB_PASSWORD' %in% listOfVars &&
        'DB_HOSTNAME' %in% listOfVars &&
        'DB_SCHEMA' %in% listOfVars) )
{
    cat('Data base login info is missing')
}

con <- dbConnect(MySQL(),
    user = DB_USERNAME,
    password = DB_PASSWORD,
    host = DB_HOSTNAME,
    dbname= DB_SCHEMA)
    
     
options(sqldf.driver = "SQLite") 

userinfo <- dbGetQuery(conn = con, statement = 
                "SELECT id, city, state, zip, age, marital_status, employer, is_deleted, is_new, devices_user_id, currenttoken, 
                        comments_message, gender, height, goal_weight, sap_num, referred_by, start_weight, start_bp_sys, start_bp_dia,
                        highest_weight, lowest_weight, member_since, a.date_added as date_added, a.date_modified as date_modified, or_coach_id, store_id, bmr, 
                        last_login, promo_code, physician_referral, other_referral, is_first_time, is_coach, is_verified, emr_patient_no,
                        hl_connection,user_disable_hl,opt_research,opt_email,homestore,lead_source,membership_purchased_date,crm_id,pos_id
                FROM userinfo a INNER JOIN userinfo_groups b on a.id =b.userinfo_id 
                WHERE b.group_id = 5 and a.date_added > '2014-01-01';
                ")   

cat('user info has been loaded. \r\n')

userinfo_notes <- dbGetQuery(conn = con, statement = 
                "SELECT id, userinfo_id, notes, created_by, is_alert, is_deleted, for_date, date_modified, date_added 
                FROM userinfo_notes;
                ")

cat('user info note has been loaded. \r\n' )

device_weight <- dbGetQuery(conn = con, statement = 
                "SELECT user_id, DATE(date_recorded) AS date_recorded, weight, substring(date_recorded, 1, 7) AS yearmo
                FROM device_weight
                WHERE weight > 100 AND weight < 1000 AND user_id !=0;
                ")   

cat('device weight has been loaded. \r\n')

device_circ <- dbGetQuery(conn = con, statement = 
                "SELECT id, user_id, date_recorded, part, measurement, from_device 
                FROM device_circ
                ")

cat('device circ has been loaded. \r\n')

activity <- dbGetQuery(conn = con, statement = 
                "SELECT id, activity_type_id, activity_intensity_id, user_id, name, duration, duration_unit, date_time, notes, is_favorite, is_deleted, date_added, date_modified 
                FROM activity
                ")

cat('activity has been loaded. \r\n')

activity_intensity <- dbGetQuery(conn = con, statement = 
                "SELECT id, name, date_added, date_modified 
                FROM activity_intensity
                ")

cat('activity intensity has been loaded. \r\n')

activity_type <- dbGetQuery(conn = con, statement = 
                "SELECT id, name, date_added, date_modified 
                FROM activity_type
                ")

cat('activity_type has been loaded. \r\n')

food <- dbGetQuery(conn = con, statement = 
                "SELECT user_id, meal_type_id, food_tag_id, date, serving, date_added, date_modified 
                FROM food_tag_log
                ")

cat('food has been loaded. \r\n')

meds <- dbGetQuery(conn = con, statement = 
                "SELECT id, user_id, medication, strength, frequency, is_custom, date_changed 
                FROM user_medications
                ")

cat('meds has been loaded. \r\n')

plans <- dbGetQuery(conn = con, statement = 
                "SELECT id, user_id, template_name, activity_level, activity_text, calories, protien, carbs, fat, fiber, date_modified, date_started, 
                    date_ended, next_consult_date, breakfast_message, snack1_message, lunch_message, snack2_message, dinner_message, snack3_message, 
                    coach_id, is_template, calories_range, protein_range, carbs_range, fat_range, fiber_range, notes, protein_pct, carbs_pct, fat_pct, 
                    current_gm_kg_day, desired_gm_kg_day, sedentary, light, moderate, very_active, extra_active 
                FROM plans
                ")

cat('plans has been loaded. \r\n')

dbDisconnect(con) 

