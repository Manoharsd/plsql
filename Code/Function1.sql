CREATE OR REPLACE FUNCTION PRDMMIS.fn_GetAnchorDt(pfrom_date DATE, pto_date DATE)
   RETURN DATE
IS 
BEGIN
   IF TRUNC(SYSDATE) BETWEEN pfrom_date AND pto_Date THEN
      RETURN TRUNC(SYSDATE);
   ELSIF TRUNC(SYSDATE) < pfrom_date THEN
      RETURN pfrom_date;
   ELSE
     -- RETURN pto_date;
     Null;
   END IF;
END; -- fn_GetAnchorD
/
