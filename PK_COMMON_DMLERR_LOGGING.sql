create or replace PACKAGE pk_common_dmlerr_logging 
AS
/******************************************************************************
         NAME:       pk_common_dmlerr_logging
         PURPOSE:    Log Bulk Exception Error in DB_OBJECT_ERROR_LOG

         REVISIONS:
         Ver        Date        Author            Description
         ---------  ----------  ---------------   -----------------------------------
         1.0        03/30/2021  Mahesh V          Adding BULK Exception Handling
         PARAMETERS:
         INPUT:
         OUTPUT: 
         RETURNED VALUE:
         CALLED BY: 
         ASSUMPTIONS:
         NOTES: 
******************************************************************************/    
    dml_errors EXCEPTION;
    PRAGMA exception_init ( dml_errors, -24381 );

    PROCEDURE pr_bulk_msg_dump;

END pk_common_dmlerr_logging;
/
create or replace PACKAGE BODY pk_common_dmlerr_logging 
AS
/******************************************************************************
         NAME:       pk_common_dmlerr_logging
         PURPOSE:    Log Bulk Exception Error in DB_OBJECT_ERROR_LOG

         REVISIONS:
         Ver        Date        Author            Description
         ---------  ----------  ---------------   -----------------------------------
         1.0        03/30/2021  Mahesh V          Adding BULK Exception Handling
         PARAMETERS:
         INPUT:
         OUTPUT: 
         RETURNED VALUE:
         CALLED BY: 
         ASSUMPTIONS:
         NOTES: 
******************************************************************************/  
    PROCEDURE pr_bulk_msg_dump IS

        v_owner              VARCHAR2(100);
        v_name               VARCHAR2(100);
        v_lineno             NUMBER;
        v_caller             VARCHAR2(100);
        v_err_stmnt          VARCHAR2(400);
        v_object_name        VARCHAR2(100);
        v_sub_routine_name   VARCHAR2(100);
    BEGIN

        owa_util.who_called_me(v_owner, v_name, v_lineno, v_caller);

        IF v_caller = 'PACKAGE BODY' THEN
            v_object_name := regexp_substr(v_name, '[^.]+', 1, 1);
            v_sub_routine_name := regexp_substr(v_name, '[^.]+', 1, 2);
        ELSE
            v_object_name := v_name;
            v_sub_routine_name := NULL;
        END IF;


        FOR i IN 1..SQL%BULK_EXCEPTIONS.COUNT
        LOOP
            v_err_stmnt := 'Error @line#'
                           || v_lineno
                           || ' Array Index -: '
                           || SQL%BULK_EXCEPTIONS(i).ERROR_INDEX
                           || ' Message -: '
                           || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

             pk_db_error.pr_log(p_object_name      => v_object_name, 
                             p_sub_routine_name  => v_sub_routine_name, 
                             p_error_code        => SQL%BULK_EXCEPTIONS(i).ERROR_CODE, 
                             p_error_msg         => v_err_stmnt, 
                             p_error_details     => v_err_stmnt );

        END LOOP;

    END pr_bulk_msg_dump;

END pk_common_dmlerr_logging;
/