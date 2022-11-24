@isTest

public class TF_SBQQ_Quote_PopulateGUIDTest {

    static testMethod void test() {

        String s = TF_SBQQ_Quote_PopulateGUID.getRandomString(25);

        System.assertEquals(25, s.length());

    }

}