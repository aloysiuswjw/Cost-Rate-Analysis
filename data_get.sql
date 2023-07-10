
-- Query Data from DBFMS
WITH
    A AS (
        SELECT
            C.COM_ID,
            C.CSL_ID,
            CT.CNTR_ID,
            CT.COST_C,
            CT.COST_DESC,
            CT.COST_RATE,
            CT.COST_UNIT,
            CT.COST_QTY,
            NVL(CT.COST_TERM, 'FP') COST_TERM,
            CT.PARTY_ID,
            CT.COST_CURR,
            CT.COST_EX_RATE,
            CT.LOC_AMT,
            CT.DOC_AMT,
            CT.DOC_TYPE,
            CT.DOC_NO,
            C.POL_ID,
            C.POD_ID,
            C.POD,
            C.VESSEL,
            C.ETD_POL_D,
            C.ETA_POD_D,
            CC.CNTR_SIZE,
            CC.CNTR_TYPE,
            T.NAME PARTY_NAME,
            C.ETA_ETD_NO
        FROM
            COSTING CT,
            CONSOL C,
            CONSOL_CNTR CC,
            TRADER T
        WHERE
            C.COM_ID = '010'
            AND C.JOB_TYPE = 'CS'
            AND CT.COM_ID = C.COM_ID
            AND CT.CSL_ID = C.CSL_ID
            AND C.COST_CENTER = 'E'
            AND CT.COM_ID = CC.COM_ID
            AND CT.CNTR_ID = CC.CNTR_ID
            AND CT.PARTY_ID = T.PARTY_ID
            AND CT.COST_C = 'OF-E-CT-CR'
            AND CT.COST_CURR = 'USD'
            AND CT.BKG_NO IS NULL
    )
SELECT
    COM_ID,
    MAX(PARTY_ID) PARTY_ID,
    MAX(PARTY_NAME) PARTY_NAME,
    CSL_ID,
    ETA_ETD_NO,
    MAX(POD_ID) POD_ID,
    MAX(POD) POD,
    MAX(ETD_POL_D) ETD_POL_D,
    CNTR_ID,
    MAX(CNTR_SIZE) CNTR_SIZE,
    MAX(CNTR_TYPE) CNTR_TYPE,
    COST_TERM,
    ABS(SUM(COST_RATE)) RATE
FROM
    A
GROUP BY
    COM_ID,
    CSL_ID,
    ETA_ETD_NO,
    CNTR_ID,
    COST_TERM;