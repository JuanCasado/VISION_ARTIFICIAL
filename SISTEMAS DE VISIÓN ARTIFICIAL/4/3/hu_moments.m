function [humom] = hu_moments(inimage)

global CENTRALMOMENT;

CENTRALMOMENT = central_moments(inimage, 3);

mu2002a111 = Mu(2,0) + Mu(0,2);
mu2002s111 = Mu(2,0) - Mu(0,2); 
mu2002s112 = mu2002s111 * mu2002s111;
	
mu3012s131 = Mu(3,0) - 3 * Mu(1,2); 
mu3012s132 = mu3012s131 * mu3012s131;
mu3012a111 = Mu(3,0) + Mu(1,2);
mu3012a112 = mu3012a111 * mu3012a111;

mu2103s311 = 3 * Mu(2,1) - Mu(0,3); 
mu2103s312 = mu2103s311 * mu2103s311;		
mu2103a111 = Mu(2,1) + Mu(0,3);	
mu2103a112 = mu2103a111 * mu2103a111;

humom(1) = mu2002a111;
humom(2) = mu2002s112 + 4 * Mu(1,1) * Mu(1,1);
humom(3) = mu3012s132 + mu2103s312;
humom(4) = mu3012a112 + mu2103a112;
humom(5) = mu3012s131 * mu3012a111 * ( mu3012a112 - 3 * mu2103a112 ) + mu2103s311 * mu2103a111 * ( 3 * mu3012a112 - mu2103a112 );
humom(6) = mu2002s111 * ( mu3012a112 - mu2103a112 )+ 4 * Mu(1,1) * mu3012a111 * mu2103a111; 
humom(7) = mu2103s311 * mu3012a111 * ( mu3012a112 - 3 * mu2103a112 ) - mu3012s131 * mu2103a111 * ( 3 * mu3012a112 - mu2103a112 );


%Helper function
function [momval] = Mu(p,q)

global CENTRALMOMENT;

alpha = (p + q + 2)/2.0 ;
momval = CENTRALMOMENT(p+1,q+1);
norm = CENTRALMOMENT(1,1) ^ alpha;

if (norm == 0)
   momval = 0;
else
   momval = momval/norm;
end
