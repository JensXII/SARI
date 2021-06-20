#' All SARS-CoV-2 tests from IB_Outbreak.SARS2.Basis_samples_deltaload.
#'
#' @param StartDate Start date.
#' @param EndDate End data.
#' @import RODBC
#' @return data all COVID19 test by date
#' @export
GetBasicSamplesCOVID19 <- function(StartDate, EndDate) {

  # StartDate <- ISOweek::ISOweek2date(paste0(substr(StartWeek,1,4), "-W", substr(StartWeek,6,7), "-1"))
  # EndDate <- ISOweek::ISOweek2date(paste0(substr(EndWeek,1,4), "-W", substr(EndWeek,6,7), "-7"))

  # Read from BasisSamples
  con <- RODBC::odbcConnect("Outbreak", readOnlyOptimize = TRUE)
  COVID19pos <- RODBC::sqlQuery(con, paste0("
    with
    #all as
        (select Cprnr10 as cprnr, cast(Prdate as date) as prdate,
        case when svar = 'positiv' then 1 else 0 end as COVID19 from
        IB_Outbreak.SARS2.Basis_samples_deltaload with(nolock)
        where (Batchid = (select max(batchID_Samples) from IB_Outbreak.historic.BatchID_Historic with(nolock))) and
              ('", StartDate, "' <= prdate) and (prdate <= '", EndDate, "') and (TestPt_adHoc <> 1))

      select cprnr, prdate, max(COVID19) as COVID19 from #all
      group by cprnr, prdate
      order by cprnr, prdate
    "), stringsAsFactors = FALSE, as.is = TRUE)
  RODBC::odbcClose(con)
  rm(con)

  return(COVID19pos)
}


