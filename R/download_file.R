#' Download file function (replacement for download.file)
#'
#' @param remote_file_url URL to download file from
#' @param local_file_path Local path to save file to
#' @param contact Requester identity (organization + contact email) appended
#'   to the User-Agent. SEC requires this to serve the Form D data sets;
#'   without it requests are blocked with a 403 "Request Rate Threshold
#'   Exceeded" page.
#' @return path to local file
#'
#' @examples
#' \dontrun{
#'   system("mkdir -p  ~/data_swamp")
#'   retrieved_file <- download_file(
#'     "https://archive.org/offshoot_assets/assets/ia-logo-2c2c2c.03bd7e88c8814d63d0fc..svg",
#'     "~/data_swamp/archive.svg",
#'     contact = "Your Organization you@example.org")
#' }
#'
#'
download_file <- function (remote_file_url, local_file_path, contact) {
  # SEC (source of the Form D data sets this package downloads) blocks
  # requests whose User-Agent does not declare the requester with a contact
  # email, returning a 403 "Request Rate Threshold Exceeded" page. `contact`
  # is appended to the User-Agent to satisfy that; pass a different literal
  # to declare a different requester.
  user_agent <- trimws(paste(
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:131.0) Gecko/20100101 Firefox/131.0",
    contact
  ))
  res <- NULL
  res <- system(
    sprintf(
      paste0("curl '%s' --compressed ",
             "-H 'User-Agent: %s' ",
             "-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8' ",
             "-H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br, zstd' ",
             "-H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' ",
             "-H 'Referer: https://broadbandmap.fcc.gov/data-download' ",
             "-H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-User: ?1' ",
             "-H 'Sec-GPC: 1' -H 'Priority: u=0, i' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'TE: trailers' ",
             "-o %s"),
      remote_file_url, user_agent, local_file_path
    )
  )

  if (is.null(res) || res > 0) {
    return(res)
  } else {
    return(invisible(local_file_path))
  }
}
