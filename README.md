# dform
Programmatic interface to SEC Form D data

## What is the SEC Form D?
Regulation D is a series of rules that govern commonly used regulatory exemptions that companies can use to sell securities.  Regulation D requires that companies file a notice of their offering with the SEC using Form D. Form D submissions are publicly available after filing, including some information from the Form ID such as the ZIP code of the filing. Because Form D applications are submitted prior to the actual Form D, information from that application may be available before the contents of the form.

Companies must file a Form D using the SEC’s electronic filer system called “EDGAR” within 15 days after the first sale of securities. An amendment is required annually if the offering is ongoing for more than 12 months, or if certain of the information in the notice changes.

## Using `dform`

```r
dfm <- dForm$new()

# Load available Form D filings for all quarters of 2020 and cache the results,
# keeping only the latest instance of accession numbers. `contact` is required
# (see "SEC access requirement" below).
dfm$load_data(
  2020, quarter = c(1:4), remove_duplicates = TRUE, use_cache = TRUE,
  contact = "Your Organization you@example.org"
)
```

## SEC access requirement

SEC's access policy requires a User-Agent that declares who you are with a
contact email. dForm's bundled downloader (`R/download_file.R`) sends a
hardcoded Firefox User-Agent string.

To fix we had to make the Form D download send a SEC-compliant User-Agent that include a contact string, so `load_data()` takes a **required** `contact` argument (no default) — your organization plus a contact email — which is threaded through to the downloader and appended to the User-Agent so SEC serves the data. Omitting it (or passing a blank/invalid value) raises a clear error up front, rather than failing later with a confusing "no data" message.
