public class TF_SBQQ_Quote_PopulateGUID {

    /**

     * Method to generate random string 

     * 

     * @param strLength determines length of returned string. Accepted values are integers from 1 to 28.

     */

    public static String getRandomString(Integer strLength) {

        Blob b = Crypto.GenerateAESKey(256);

        String h = EncodingUtil.base64Encode(b);

        

        return h.remove(' ')

                .remove('/')

                .remove('+')

                .remove('=')

                .substring(0, strLength);

    }

}