#' Create a list of random nodes
#' @description Generate a list of random nodes used for example or test.
#' @param txdb An TxDb object.
#' @param seq seqlevels to be kept.
#' @param size the length of regions involved in nodes
#' @param upstream,downstream upstream or downstream for promoters
#' @param maxDist maximal distance from promoters
#' @param wid regions width.
#' @return An GRanges object with comp_id metadata.
#' @export
#' @importMethodsFrom GenomicFeatures genes promoters
#' @importMethodsFrom IRanges shift trim width<-
#' @importFrom GenomeInfoDb seqlevels
#' @importFrom GenomicRanges seqnames
#' @examples 
#' library(TxDb.Hsapiens.UCSC.hg19.knownGene)
#' set.seed(123)
#' node_regions <- createRandomNodes(TxDb.Hsapiens.UCSC.hg19.knownGene)
createRandomNodes <- function(txdb, seq="chr22", size=500,
                             upstream=500, downstream=500,
                             maxDist=1e6, wid=5000){
  stopifnot(is(txdb, "TxDb"))
  stopifnot(is(seq, "character"))
  stopifnot("Not all input seqlevels in TxDb object"=
              all(seq %in% seqlevels(txdb)))
  stopifnot(is.numeric(size))
  stopifnot(is.numeric(upstream))
  stopifnot(is.numeric(downstream))
  stopifnot(is.numeric(maxDist))
  stopifnot(is.numeric(wid))
  g <- genes(txdb)
  g <- g[which(as.character(seqnames(g)) %in% seq)]
  p <- promoters(g, upstream = upstream, downstream = downstream)
  dist <- sample.int(maxDist, size = size, replace = TRUE)
  idx <- sample(seq_along(p), size = size, replace = TRUE)
  regions <- p[idx]
  regions <- shift(regions, shift = dist)
  width(regions) <- wid
  regions <- trim(regions)
  comp_id <- sample.int(ceiling(size/10), size=length(regions), replace = TRUE)
  regions$comp_id <- as.character(comp_id)
  regions[order(comp_id)]
}
