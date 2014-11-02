require 'minitest'
require 'minitest/autorun'

require 'genevalidator/validation_test'
require 'genevalidator/validation_open_reading_frame'
require 'genevalidator/sequences'

class TestORFValidation < Minitest::Test

  describe "ORF Validation" do

    it "should find ORFs - test 1 " do

      prediction = Sequence.new
      prediction.raw_sequence =
       "ATGGCTCTCTGGATCCGGTCGCTGCCTCTCCTGGCCCTTCTTGCTCTTTCTGGCCCTGGGATCAGCCACG\
CAGCTGCCAACCAGCACCTCTGTGGCTCCCACTTGGTTGAGGCTCTCTACCTGGTGTGTGGGGAGCGGGG\
TTTCTTCTACTCCCCCAAAACACGGCGGGACGTTGAGCAGCCTCTAGTGAACGGTCCCCTGCATGGCGAG\
GTGGGAGAGCTGCCGTTCCAGCATGAGGAATACCAGAAAGTCAAGCGAGGCATCGTTGAGCAATGCTGTG\
AAAACCCGTGCTCCCTCTACCAACTGGAAAACTACTGCAACTAG"

      validation = OpenReadingFrameValidation.new(:nucleotide, prediction, nil, "", ["ATG"], ["TAG", "TAA", "TGA"])
      result = {1=>[[0, 324]], 2=>[[202, 324]], 3=>[], -1=>[], -2=>[[146, 263]], -3=>[]}
      assert_equal(result, validation.get_orfs)

      validation = OpenReadingFrameValidation.new(:nucleotide, prediction, nil, "", [], ["TAG", "TAA", "TGA"])
      result = {+1=>[[1, 324]], +2=>[[2, 187], [190, 324]], +3=>[[3, 110]], -1=>[[183, 323], [0, 183]], -2=>[[146, 296], [0, 116]], -3=>[[61, 250]]}
      assert_equal(result , validation.get_orfs)
    end

    it "should find - test 2 " do
      prediction = Sequence.new
      prediction.raw_sequence =
       "ATGGCTCTCTGGATCCGGTCGCTGCCTCTCCTGGCCCTTCTTGCTCTTTCTGGCCCTGGGATCAGCCACGCA\
GCTGCCAACCAGCACCTCTGTGGCTCCCACTTGGTTGAGGCTCTCTACCTGGTGTGTGGGGAGCGGGGTTTCT\
TCTACTCCCCCAAAACACGGCGGGACGTTGAGCAGCCTCTAGTGAACGGTCCCCTGCATGGCGAGGTGGGAGA\
GCTGCCGTTCCAGCATGAGGAATACCAGACAGCACCTCTGTGGCTCCCACTTGGTTGAGGCTCTCTACCTGGT\
GTGTGGGGAGCGGGGTTTCTTCTACTCCCCCAAAACACGGCGGGACGTTGAGCAGCCTCTAGTGAACGGTCCC\
CTGCATGGCGAGGTGGGAGAGCTGCCGTTCCAGCATGAGGAATACCAGAAAGTCAAGCGAGGCATCGTTGAGC\
AATGCTGTGAAAACCCGTGCTCCCTCTACCAACTGGAAAACTACTGCAACTAG"

      validation = OpenReadingFrameValidation.new(:nucleotide, prediction, nil, "", ["ATG"], ["TAG", "TAA", "TGA"])
      result = {1=>[[0, 276]], 2=>[[202, 490]], 3=>[[368, 490]], -1=>[], -2=>[[312, 429]], -3=>[]}
      assert_equal(result, validation.get_orfs)

      validation = OpenReadingFrameValidation.new(:nucleotide, prediction, nil, "", [], ["TAG", "TAA", "TGA"])
      result = {+1=>[[1, 276]], +2=>[[2, 187], [190, 490]], +3=>[[3, 110], [236, 353], [356, 490]], -1=>[[349, 489], [61, 349]], -2=>[[312, 462], [0, 183]], -3=>[[146, 416], [0, 116]]}
      assert_equal(result , validation.get_orfs)
    end

    it "should find - test 3 " do
      prediction = Sequence.new
      prediction.raw_sequence =
       "GGCGGGGCGGGAGGGCGGCGCGGAGTGCGCCGGCGCGTCGTCGGGGACGCCGGGTCCAGGATCTTGCTAGGGAACCAGTGTTGTCGCGTCGTCCC\
GCCCCCTCGGGGCTTTTGCTCCCGTTAACTGTCGGCGGGGCAGGCTCCGCAGCGCAGGGCGACATGCCGGTGCGCTTCAAGGGGCTGAGTGAATACC\
AGAGAAACTTCCTGTGGAAAAAGTCCTATTTGTCAGAGTCTTATAATCCCTCAGTGGGACAAAAGTACTCATGGGCAGGACTTAGATCGGATCAGTT\
GGGGATCACGAAAGAACCAGGTTTTATTTCAAAAAGAAGAGTTCCCTACCATGACCCTCAGATTTCAAAATACCTGGAGTGGAACGGAACCGTCAGA\
AAGAAGGATACGCTTGTCCCACCAGAACCCCAGGCCTTTGGAACGCCAAAGCCACAAGAGGCTGAGCAAGGAGAAGATGCCAATCAAGAAGCAGTTC\
TCTCACTAGAGGCCTCCAGGGTTCCCAAGAGAACTCGGTCTCATTCTGCGGACTCGAGAGCTGAAGGGGTTTCAGACACTGTGGAAAAGCACCAGGG\
TGTCACGAGAAGCCATGCGCCAGTTAGCGCGGATGTGGAGCTGAGACCTTCCAGCAAACAACCTCTCTCCCAGAGCATAGATCCCAGGTTGGATAGG\
CATCTTCGTAAGAAAGCTGGATTGGCCGTTGTTCCCACGAATAATGCCTTGAGAAATTCTGAATACCAAAGGCAGTTTGTTTGGAAGACTTCTAAAG\
AAAGCGCTCCAGTGTTTGCATCCAATCAGGTTTTCCGTAATAAAAGCCAAATTATTCCACAGTTCCAAGGCAATACATTCACCCACGAGACTGAATA\
CAAGCGAAATTTCAAGGGTTTAACTCCAGTGAAGGAACCAAAGTCAAGAGAGTATTTGAAAGGAAACAGCAGTCTGGAGATGCTGACTCCAGTAAAG\
AAGGCAGATGAGCCTTTAGACTTAGAAGTAGACATGGCGTCGGAAGACTCAGACCAGTCTGTAAAGAAGCCTGCTTCATGGAGACACCAAAGGCTTGGAAAAGTGAATTCTGAATATAGAGCAAAGTTCCTGAGCCCAGCCCAGTATTTCTATAAAGCTGGAGCTTGGACCCGGGTGAAGGAGAACCTGTCAAACCAGGTTAAGGAGCTCCGAGAAAAGGCCGAATCTTACAGGAAGCGAGTTCAGGGGACACATTTTTCTCGGGACCATCTGAACCAGATTATGTCGGACAGCAACTGCTGTTGGGACGTCTCCTCAGTCACAAGCTCGGAAGGCACCGTCAGTAGCAACATCCGAGCACTGGATCTTGCTGGAGACCTTACAAACCACAGGACCCCCCAGAAACACCCTCCTACCAAACTAGAAGAAAGAAAAGTTGCCTCGGGAGAGCAGCCCCTGAAAAACTCCACCAGGAGACTGGAGATGCCAGAGCCTGCCGCCTCGGTCAGGAGGAAGCTGGCTTGGGATGCTGAGGAGAGCACGAAGGAAGACACCCAGGAGGAGCCCAGGGCGGAGGAGGACGGGAGAGAGGAGAGAGGACAGGACAAGCAGACCTGTGCGGTAGAGCTGGAGAAACCGGACACACAGACACCCAAGGCAGACAGACTGACAGAAGGGTCGGAGACATCTTCTGTTTCCTCAGGGAAGGGAGGCAGGCTTCCTACACCGAGGCTGAGAGAACTCGGTATCCAGCGGACGCACCATGATCTCACGACGCCAGCTGTTGGTGGCGCAGTCTTAGTGTCTCCATCTAAAGTGAAGCCACCAGGCCTCGAGCAGAGGAGGAGAGCGTCCTCCCAAGATGGCTTAGAAACTCTGAAGAAAGACATTACTAAGAAAGGAAAACCCCGTCCCATGTCTCTGTTGACTTCTCCGGCTGCTGGCATGAAGACAGTTGATCCCCTGCCTCTGCGAGAAGACTGTGAAGCCAATGTGCTCAGATTTGCTGATACTCTTCCTGTTTCGAAAATTTTGGACCGTCAGCCCAGCACCCCTGGGCAGCTGCCTCCATGTGCCCCGCCTTACTGTCATCCGTCCAGCAGGATCCAGGGCCGTCTGCGAGACCCTGAGTTTCAGCACAACAATGCAGATAGACTGTCTGAGATCTCTGCTCGCTCTGCAGTTTCCAGCCTCCGGGCTTTCCAGACTCTAGCCCGAGCTCAGAAAAGAAAGGAGAATTTCTGGGGCAAGCCATAAACCTCTCATCTTATCTAGTGACAAGCTGGCTCATCTTTACTCACTCAGTGTGTTAAGGTTTTCAGAGGGTTTGGAGTTTCTTCTAACACTTCTGACTCAGATAATTTGAATTTTCAGTGGCTCATCTTAGCCAGAAAATTGCCATGCAGCTGTGTCTAAGTCTGACTCTTTGAGAGCACCTTTGCACTTGTCTGAGTACAAAGGTGCGGGGTTGTGTATTTCTTCACACACTCTTGACTTTTGTGTCAGGTCTCGGGGGTTGCTAGTAGAAGCCTGAAGGTCATCTACAGAATATTCTAAAGGGAGAAAATGAAGTCAACATTAAGATCTTCCAACTTAATTTCCCCTCAGATTGGTCTTAGGCATTTTAATAGCTGTAGGTGTCATGAAAAGAATCTCACTGTTTTATTAGCGCCTTCTGTATACACAGGTGCAGTGTTAAGATGATTGGACTTTGAAAAGCTGGCTGTACATATTTTTCTTATTTATGTAACAAAATTTGCTGAGAGAATATGTATATTTTTGATCTTTTTATGTATTTTATTTGTATAATAACTGGCATACATTTGAATAATGTCTAGATTTTGAAAAATGATTTGTGAAATGGAGAATTAAAATTTTGTAGACATTTAAAAATGAAAATTAAGTGTGCTTGGCTTCTTCAGGAAGTTATCATGTGGAATAAATATCTTCTAGAAGCATTCTATTAGAACTGCTTAATCAAAAATTATACTACTATTGCAGCTGCTAAATGCAGTGAAACTGAGTCTACAGTATTTTTTTTTTCACAAATACGAGGTTTTAAAAACAGATTCATTAAAAAATTTAAACACCAAAAAAAAAAAA"
      validation = OpenReadingFrameValidation.new(:nucleotide, prediction, nil, "", [], ["TAG", "TAA", "TGA"])
      result = {1=>[[1, 123], [183, 492], [492, 624], [729, 894], [1242, 1392], [1428, 1593], [1917, 2181], [2181, 2334], [2355, 2502]], 2=>[[70, 187], [343, 451], [868, 979], [979, 1081], [1171, 1315], [1315, 1501], [1501, 1735], [1978, 2098], [2131, 2281], [2827, 2935], [2935, 3071]], 3=>[[3, 2225], [2246, 2384], [2525, 2672], [2672, 2777], [2945, 3071]], -1=>[[2765, 2867], [2351, 2540], [1835, 2177], [1388, 1667], [1283, 1388], [1157, 1283], [1043, 1157], [554, 890], [353, 485], [119, 224], [0, 119]], -2=>[[2710, 2836], [2608, 2710], [1210, 2008], [799, 1117], [523, 799], [346, 469], [0, 217]], -3=>[[2952, 3068], [2346, 2448], [1965, 2235], [1860, 1965], [1473, 1689], [882, 1167], [603, 768], [381, 582], [171, 273], [66, 171]]}
      assert_equal(result, validation.get_orfs)
    end
  end
end
