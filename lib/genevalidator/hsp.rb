require 'genevalidator/blast'
require 'genevalidator/exceptions'

module GeneValidator
  # A class that initialises the BLAST tabular attributes
  class Hsp
    attr_accessor :hit_from # ref. from the unaligned hit sequence
    attr_accessor :hit_to
    attr_accessor :match_query_from # ref. from the unaligned query sequence
    attr_accessor :match_query_to
    attr_accessor :query_reading_frame
    attr_accessor :hit_alignment
    attr_accessor :query_alignment
    attr_accessor :middles # conserved residues are with letters,
    # positive (mis)matches with +, mismatches and gaps are with space

    attr_accessor :bit_score
    attr_accessor :hsp_score
    attr_accessor :hsp_evalue
    attr_accessor :identity # number of conserved residues
    attr_accessor :pidentity # percentage of identical matches
    attr_accessor :positive # positive score for the (mis)match
    attr_accessor :gaps
    attr_accessor :align_len

    def initialize
      @query_alignment = nil
      @hit_alignment   = nil
    end

    ##
    # Initializes the corresponding attribute of the hsp
    # with respect to the column name of the tabular blast output
    # Params:
    # +column+: String with column name.
    # +value+: Value of the column
    def init_tabular_attribute(hash)
      @match_query_from    = hash['qstart'].to_i if hash['qstart']
      @match_query_to      = hash['qend'].to_i if hash['qend']
      @query_reading_frame = hash['qframe'].to_i if hash['qframe']
      @hit_from            = hash['sstart'].to_i if hash['sstart']
      @hit_to              = hash['send'].to_i if hash['send']
      @query_alignment     = hash['qseq'] if hash['qseq']
      @hit_alignment       = hash['sseq'] if hash['sseq']
      @align_len           = hash['length'].to_i if hash['length']
      @pidentity           = hash['pident'].to_f if hash['pident']
      @identity            = hash['nident'].to_f if hash['nident']
      @hsp_evalue          = hash['evalue'].to_f if hash['evalue']
      assert_seq_type(@query_alignment) if hash['sseq']
      assert_seq_type(@hit_alignment) if hash['sseq']
    end

    def assert_seq_type(query)
      seq_type = BlastUtils.guess_sequence_type(query)
      fail SequenceTypeError if seq_type != :protein
    rescue SequenceTypeError => e
      $stderr.puts e
      $stderr.puts 'Rescuing SequenceTypeError (HSP): Ignoring the fact' \
                   " that following sequence was suppsoed to be a protein: " \
                   "\n #{query}"
    end
  end
end
