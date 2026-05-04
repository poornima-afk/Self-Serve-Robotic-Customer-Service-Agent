public class EMIManagement {
    
    public class RequestEMI{
        @InvocableVariable
        public Double monthInterest;
        
       	@InvocableVariable
		public Double tenure;
		
        @InvocableVariable    
		public Decimal principleAmount;
    }
    
    public class ResponseEMI{
        @InvocableVariable
        public Decimal newEMI;
    }
	
    @InvocableMethod(label = 'Get new EMI Balance')
    public static List<ResponseEMI> getNewEMIBalance(List<RequestEMI> req){
        List<ResponseEMI> result = new List<ResponseEMI>();
        for(RequestEMI r : req){
            ResponseEMI res = new ResponseEMI();
            res.newEMI = Math.round(r.principleAmount * r.monthInterest * Math.pow((1 + r.monthInterest),r.tenure) /  (Math.pow((1 + r.monthInterest),r.tenure) - 1));
            
            result.add(res);
        }
        
        return result;
    }
}