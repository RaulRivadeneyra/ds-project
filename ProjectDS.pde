// ===============================================
import java.util.HashSet;
import java.util.Set;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;
 
class Node {
  float px, py;
  int id;
  boolean isSelected=false;
 
  Node(int _id, float _x, float _y) {
    id = _id;
    px = _x;
    py = _y;
  }
 
  void draw() {
    float scaledX = finalPositionX(px);
    float scaledY = finalPositionY(py);
    
    if (!mouseDown) {
      isSelected=false;
      
    } // if
  /*
    fill(0);
    textAlign(CENTER, CENTER);
    text(str(id), scaledX, scaledY - (5 * scaleRatio));
*/
    stroke(0);
    fill(38, 224, 239); // blue
    if (dist(mouseX, mouseY, scaledX, scaledY) <= (4 * scaleRatio)) {
      fill(157, 38, 239);
      if (!mouseDown) {
        isSelected=true;
      } // if
    } // if
    ellipse(scaledX, scaledY, 5 * scaleRatio,5 * scaleRatio);
  } // method

} // class 
 
// ===============================================
 //  - px  = (-mouseX + px)/(scaleRatio - 1) + (width/2)
class Link {
  int id;
  Node from;
  Node to;
  float distance;
  boolean highlighted = false;
 
  Link(int _id, Node _from, Node _to) {
    id = _id;
    from=_from;
    to=_to;
    distance = dist(from.px,from.py, to.px, to.py) * conversionRate;
  }
 
  void draw() {
    float p1x=-1, p1y=-1, p2x=-1, p2y=-1;
    
    p1x = finalPositionX(from.px);
    p1y = finalPositionY(from.py);
    p2x = finalPositionX(to.px);
    p2y = finalPositionY(to.py);
    
    if(!highlighted){
      stroke(100);
    }else{
      stroke(255,0,0);
    }
    line(p1x, p1y, p2x, p2y);
    /*
    fill(0);
    textAlign(CENTER, CENTER);
    text(str(id), (p1x + p2x)/2, (p1y + p2y)/2 - 10);
    */
  }
} // class 

class Wall{
  int id;
  float x1, y1, x2, y2;
  Wall(int _id,float _x1, float _y1, float _x2, float _y2){
    id = _id;
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
  }
  void draw(){
   stroke(0,255,0);
   line(finalPositionX(x1),finalPositionY(y1),finalPositionX(x2),finalPositionY(y2));
  }
}
 
// ===========================================
 
 
Map<Integer, Node> nodes = new HashMap<Integer, Node>();
Map<Integer, Wall> walls = new HashMap<Integer, Wall>();
Map<Integer, Link> links = new HashMap<Integer, Link>();
ArrayList<Link> path = new ArrayList<Link>();

float[][] matrix;

boolean mouseDown=false;
boolean mouseDownRight=false;
Node nodeSelected;
int numberOfLinks = 0;
int numberOfNodes = 0;
int numberOfWalls = 0;
boolean newNode = false;
boolean selection = false;
boolean fromKey = false;
boolean toKey = false;
boolean deleteNode = false;
boolean locked = false;
boolean debouncer = false;
boolean changed = false;
boolean moved = false;

boolean shift = false;

//Image settings
PImage img;

//Camera Control
float scaleRatio = 1;
float offsetX = 0;
float offsetY = 0;

float conversionRate = 0.1333; // 1 unit = 0.1333 meters
int searchRadius = 4; // meters to search around node
boolean toggleGraph = true;
boolean toggleNodes = true;
boolean toggleWalls = true;
boolean toggleMap = true;

float lineX = 0;
float lineY = 0;



Node selectFromNode;
Node selectToNode;
 
 

void setup() {
  size(1013, 560);
  loadNodes("610.947,182.1963;610.2981,203.97516;605.3461,228.30212;614.5528,228.06172;609.74506,249.16753;637.9175,255.54135;615.9545,271.91266;639.97626,275.2868;587.2464,268.066;575.05676,295.217;601.8008,288.87573;630.292,289.8766;591.67725,315.83667;619.70135,309.30746;644.38025,311.87296;662.3131,239.20428;645.1309,231.64413;660.9385,263.60294;659.22034,286.97067;680.1825,289.71982;704.96686,264.93448;704.76904,312.7815;703.9647,289.83664;731.6816,289.15494;676.7461,248.48267;665.9374,221.20816;660.6571,203.83807;638.25806,216.1802;631.32184,198.71777;640.4135,182.65889;669.9033,183.19049;698.3602,183.25278;726.3489,182.56549;759.22046,209.99463;760.9386,236.94397;762.0034,265.0695;760.3738,288.55673;759.22046,314.11847;761.09546,355.64127;759.1001,335.55212;735.13635,349.48578;728.59973,361.91812;702.98535,362.60434;706.27686,351.3061;682.511,334.84955;695.2441,353.5466;663.6445,351.6345;674.00464,364.07623;648.9623,366.43854;630.5565,389.98727;645.30725,399.53043;697.167,392.0681;673.27124,393.16748;720.2759,403.23413;724.3013,386.49683;746.1233,399.63245;739.7402,423.72256;767.65393,411.56006;750.1119,371.44373;776.1551,377.15894;804.82983,377.3999;825.90875,397.03403;805.0707,412.58072;786.5165,396.43607;819.28766,425.35175;837.36,424.3879;856.87805,422.4601;877.119,425.35178;906.28436,425.76636;896.5309,404.9274;908.5029,389.19745;881.67773,385.16928;854.2274,389.93002;943.91583,359.79974;988.2033,375.7131;942.4203,339.32755;938.0619,384.31354;973.7456,358.36374;967.17126,383.23975;932.9748,424.2434;979.4809,426.34488;987.143,401.0427;1004.589,421.49634;874.3969,448.21307;903.43585,446.38428;932.3158,444.88544;961.7246,446.1066;991.40436,447.6087;986.0074,473.63162;957.29095,472.14603;928.80597,470.53003;899.5311,473.9093;870.6708,472.43347;880.5244,499.53714;905.3328,503.18423;933.527,498.858;962.1428,500.47754;991.67194,502.63876;818.46014,504.7242;818.615,492.545;815.172,472.9045;844.9176,453.19763;803.3953,449.29504;782.1069,444.1092;789.38934,471.28946;824.34235,452.75516;843.95355,476.6866;799.5636,497.44543;763.9309,468.6494;722.09406,439.9269;789.7732,424.87003;760.537,440.10303;740.71686,459.34402;752.21173,486.58575;778.767,496.78174;755.5508,509.1186;785.6255,524.2154;724.121,524.2154;729.0325,496.5356;750.6697,535.4986;773.37714,538.5877;728.9882,555.85266;705.3156,537.71106;703.98816,556.95886;678.32446,556.95886;649.3034,556.99756;633.24146,541.8012;604.8017,543.53815;581.2005,557.40137;557.1274,556.87115;569.6895,504.79123;612.5039,521.19446;561.89886,538.7937;548.67834,522.1365;542.64124,493.70383;574.9894,480.3698;619.03235,493.68445;598.5046,497.8479;620.96497,463.82993;593.8111,474.43665;551.6224,475.18817;552.6644,452.4096;527.96967,485.95944;529.7103,456.47064;503.988,458.7286;646.92126,466.72253;569.2536,451.64905;537.15753,434.9355;564.97266,405.00354;593.10547,433.54956;565.71375,424.2155;598.58716,452.80096;613.9156,413.13684;619.0324,434.83484;591.82794,413.29443;547.1297,379.96753;553.76685,401.649;557.3704,378.2888;542.0412,409.17114;527.66064,407.40118;531.64294,380.18878;518.14734,375.3215;529.2093,354.08255;511.0677,289.25946;529.43054,290.36566;530.9792,334.61353;529.87305,311.6046;552.28455,285.0034;555.53674,314.2595;558.1915,362.7109;553.9881,338.15335;580.09436,340.58694;561.28894,256.51608;552.27075,232.66145;579.4306,239.48068;588.94385,220.89658;581.64294,197.66647;583.19165,181.07355;611.6583,152.77669;612.2186,122.91614;592.14886,112.90522;612.61646,92.93112;626.5545,84.83452;656.35205,83.80142;685.0299,82.73985;711.38385,83.109215;739.73254,83.7872;668.51495,106.587204;697.27985,106.851204;758.7461,106.49799;722.79346,107.62213;741.1564,123.330124;594.91473,389.27582;589.0672,360.1533;615.3482,373.17673;603.89307,340.35934;630.68286,350.1357;624.2308,329.30377;662.4071,324.87946;669.21826,310.01874;689.65173,208.78021;693.6677,230.06412;713.2073,207.86304;718.13464,236.64401;734.1874,225.42593;556.0676,183.29735;498.92136,182.55602;470.08978,182.90039;527.732,204.75543;529.5536,232.30272;530.38153,261.64966;506.7488,225.46376;501.72577,200.73068;485.0769,223.66724;472.01273,199.87138;461.478,223.33134;444.54178,190.51395;423.6639,177.5498;396.50665,182.83931;372.07043,184.63159;563.1084,118.71473;534.4433,120.08774;505.97894,121.208176;457.4013,119.835205;458.32437,89.989;502.13992,95.56366;529.40137,91.527466;556.3551,92.39537;583.2477,86.91207;583.0564,63.109406;553.97205,62.530205;524.9474,63.595497;496.62054,67.82476;467.98615,64.77112;448.64395,163.25568;453.29514,141.55023;425.38815,150.07736;325.53586,184.65646;316.14355,241.51196;324.8554,213.52538;302.31723,272.1331;282.38483,241.99646;278.67218,268.77304;300.58774,301.80405;297.01306,257.42435;318.75372,305.80273;291.18906,311.65057;280.17316,294.1718;291.98114,323.76108;321.45465,323.27832;325.62766,295.9505;325.0899,269.98715;325.03485,241.20734;570.2991,375.6547;754.9867,183.46716;738.4241,204.09216;646.1388,337.1088;583.62683,523.3461;832.99146,376.9606;943.92255,405.3007;960.11707,412.18335;721.6554,468.45865;788.2367,206.03244;815.4668,206.03244;779.78595,181.14978;777.908,156.26715;775.0911,131.38452;837.53235,205.56294;865.23193,206.5019;892.4619,208.84932;921.56995,209.3188;950.67786,211.19673;978.37744,221.99484;1001.85156,238.42674;527.8249,183.05959;349.2534,183.39969;282.58673,221.15483;268.301,321.49515;243.13089,323.87595;480.93604,109.596985;640.6001,116.319595");
  loadWalls("628.2162,459.71548,628.8698,400.56512;628.8698,400.56512,652.3993,377.68927;652.3993,377.68927,735.73267,377.3625;628.8698,406.44748,712.53,405.4671;712.53,405.4671,712.53,511.02274;712.53,511.02274,628.2162,512.32996;628.2162,512.32996,628.2162,473.1142;628.21625,512.6567,672.6607,555.4672;672.3339,555.794,712.53,511.0227;678.87683,343.56808,667.0176,355.0254;667.0176,355.0254,689.6306,355.0254;689.6306,355.0254,678.67584,343.56808;671.53815,335.65588,602.7981,404.39587;602.7981,404.39587,570.9002,404.55542;570.9002,404.55542,571.0597,382.70532;571.0597,382.70532,592.1123,404.2364;559.45013,382.07382,559.5513,404.62183;559.5513,404.62183,546.91223,404.72296;546.91223,404.72296,547.31665,383.99493;553.4845,396.0273,554.39453,375.90598;554.39453,375.90598,540.9466,376.41153;540.9466,376.41153,540.44104,404.52072;540.44104,404.52072,535.1832,404.41962;535.16907,404.70886,535.4124,294.24646;535.4124,294.24646,547.33453,294.00314;547.33453,294.00314,546.6046,375.99838;546.6046,375.99838,560.47327,375.02515;560.47327,375.02515,599.4028,336.33896;599.4028,336.33896,588.45386,333.17593;588.45386,333.17593,582.61444,329.76962;582.61444,329.76962,578.47815,325.63336;578.47815,325.63336,571.66547,318.82068;571.66547,318.82068,569.4757,314.68445;569.4757,314.68445,566.3127,309.33163;566.3127,309.33163,563.393,303.7355;563.393,303.7355,561.44653,294.48975;561.44653,294.48975,561.6898,283.05423;561.6898,283.05423,564.3662,271.862;564.36615,272.59192,568.0158,264.5627;567.75116,264.94522,574.1086,255.66687;574.1086,255.66687,581.8405,248.794;581.8405,248.794,588.7134,245.3576;588.7134,245.3576,594.899,242.09299;594.899,242.09299,601.42816,239.51566;587.5106,207.7287,587.68243,188.14105;587.167,188.14105,596.6172,188.3129;596.6172,188.3129,595.9299,242.09299;601.42816,239.85931,603.31824,188.3129;603.3182,188.82834,596.4453,188.31287;609.5038,238.48473,610.0192,221.3026;617.923,239.8593,619.12573,189.00017;619.12573,189.00017,632.0123,189.17198;618.4385,223.19261,652.6309,223.19261;618.7821,169.06888,618.7821,178.8627;618.7821,178.8627,763.4557,178.17542;763.4557,178.17542,762.2529,136.9383;762.2529,136.9383,631.3251,136.76645;631.3251,136.76645,630.63776,168.55344;630.63776,168.55344,618.7821,169.24069;756.06726,224.05174,726.85767,252.40228;726.85767,252.40228,683.0432,252.23044;683.0432,252.23044,682.01227,280.7528;682.01227,280.7528,665.00195,280.58096;664.6583,295.35764,682.3559,295.35764;682.3559,295.35764,682.6995,324.39545;682.6995,324.39545,727.2013,323.87997;727.2013,323.87997,727.5449,295.52945;727.5449,295.52945,745.4143,295.70126;744.727,280.40915,727.88855,280.581;727.88855,280.581,727.0294,252.40228;682.6995,324.56726,704.0054,347.76312;687.3387,341.23395,700.9126,354.29236;700.9126,354.29236,726.5139,354.63602;782.5507,336.04758,781.9573,347.0268;781.9573,347.0268,796.4973,346.1366;796.4973,346.1366,796.79407,363.64404;796.79407,363.64404,873.9455,365.42447;873.9455,365.42447,876.6161,375.8102;876.6161,375.8102,876.91284,351.47784;876.91284,351.47784,905.993,351.47784;905.993,351.47784,905.1028,372.84286;905.1028,372.84286,922.907,371.6559;922.907,371.6559,922.6102,350.58765;922.6102,350.58765,938.3373,350.88437;950.5035,350.2909,971.5717,346.1366;970.97815,346.73004,1005.39954,379.96454;994.42035,371.06244,995.0138,239.01479;995.0138,239.01479,866.8237,238.12457;866.8237,238.12457,847.5359,220.02367;847.5359,220.02367,833.58923,236.04742;833.58923,236.04742,794.7168,236.93764;794.7168,236.93764,793.23315,335.75082;793.23315,335.75082,782.2539,336.64102;829.6669,399.47357,894.7125,398.5617;904.8871,372.70776,904.8871,385.84943;904.8871,385.84943,922.1356,386.46545;922.1356,386.46545,922.9569,371.2704;905.0924,394.4737,904.0658,418.08765;904.0658,418.08765,922.9569,418.70367;922.9569,418.70367,923.16223,393.44702;923.16223,393.44702,904.8871,394.063;840.553,497.52844,840.1798,521.0359;840.1798,521.0359,857.344,521.5956;857.344,521.5956,856.7843,497.715;856.7843,497.715,840.92615,497.52844;805.6649,499.5807,805.29175,518.05084;805.29175,518.05084,820.77686,518.2374;820.77686,518.2374,820.77686,499.9538;815.7395,500.32693,805.47833,499.76724;555.4399,426.84686,549.0399,435.7469;549.0399,435.7469,559.9399,436.84686;559.9399,436.84686,555.4399,426.94684;629.1647,89.502396,628.9845,108.06096;628.9845,108.06096,643.5791,107.88078;643.5791,107.88078,644.84033,88.78169;644.84033,88.78169,629.1647,89.32222;628.9845,77.97084,629.7052,41.033875;629.7052,41.033875,763.03864,40.673523;763.03864,40.673523,762.31793,78.5114;762.31793,78.5114,628.8043,78.15102;597.63306,176.70964,465.92126,176.34929;465.92126,176.34929,465.7411,141.3943;465.7411,141.3943,599.0745,140.85378;599.0745,140.85378,597.81323,176.88985;535.29065,189.50247,535.29065,278.6917;535.29065,278.6917,547.72314,277.971;547.72314,277.971,546.8222,227.16016;546.8222,227.16016,578.534,228.6016;578.534,228.6016,578.89435,204.81781;578.89435,204.81781,535.29065,205.53851;587.1826,208.06105,596.1916,208.06105;525.15045,235.10568,465.7519,235.35631;465.7519,235.35631,465.7519,348.89032;465.7519,348.89032,524.64923,349.39157;524.64923,349.39157,525.65173,294.75488;525.65173,283.97794,524.89984,235.35631;524.6492,401.52197,465.7519,401.0207;465.7519,401.0207,466.50375,508.7903;466.50375,508.7903,441.44107,508.7903;466.2531,509.29156,521.64166,509.29156;524.14795,402.52448,524.39856,452.64984;524.14795,460.1687,522.89484,508.79028;522.64417,509.0409,532.41864,508.53967;532.41864,508.53967,532.41864,474.20374;854.47107,139.78777,852.2919,188.69826;852.2919,188.69826,887.1587,190.15105;896.35974,190.39317,932.43726,191.36171;932.43726,191.36171,935.3428,141.96693;935.3428,141.96693,897.32825,140.51414;885.70593,140.51414,853.98676,139.78777;1013.0669,143.90395,999.50745,144.14607;999.50745,144.14607,998.53894,195.96214;998.53894,195.96214,1013.30896,195.23573;1012.8246,34.21852,1000.47595,35.187042;1000.47595,35.187042,998.53894,101.530975;998.53894,101.530975,1013.0668,101.04672;236.12695,-1.1542358,239.60187,34.36708;239.60187,34.36708,360.83774,32.4366;360.83774,32.4366,360.06552,-1.1542358;371.26248,175.29414,372.4208,45.95015;372.4208,45.95015,333.03842,46.72235;333.03842,46.72235,331.49402,175.68025;331.49402,175.68025,372.0347,175.68025;370.87643,189.57988,367.01547,368.73096;367.01547,368.73096,218.75247,369.50317;219.52469,370.6615,219.9108,330.50693;219.9108,330.50693,329.94968,329.73474;329.94968,329.73474,330.7219,188.42157;330.7219,188.42157,370.87643,189.19377;322.22766,228.96223,321.06934,317.37946;305.4271,245.59772,305.2291,194.3105;305.2291,194.3105,240.87256,196.29071;305.0311,232.13232,288.79343,231.7363;278.10037,232.13232,259.88248,232.52838;259.88248,232.52838,258.89243,277.87497;258.89243,277.87497,238.69434,277.47894;240.67456,196.88475,238.89236,277.87497;227.20917,306.38986,238.69434,305.79578;238.69434,305.79578,238.89233,277.4789;258.8924,278.07297,257.11017,306.98392;298.9392,272.86273,297.86395,306.84128;297.86395,306.84128,314.20807,306.62622;305.17578,273.50787,304.74567,301.03482;304.74567,301.03482,320.87476,300.81976;320.87473,312.43268,298.079,312.43268;227.1112,306.62622,221.51978,318.66925;221.51978,318.66925,190.76706,319.3144;172.3631,319.69586,137.53156,318.85315;137.53156,318.85315,139.21695,187.11127;139.21695,187.11127,225.17224,187.67307;225.17224,187.67307,226.8576,307.0554;153.8237,375.31396,155.22821,334.02173;155.22821,334.02173,136.96976,334.02173;61.172882,189.28645,27.839386,188.69121;27.839386,188.69121,20.696503,500.00208;20.696503,500.00208,140.33987,500.59732;140.33987,500.59732,138.55417,463.09717;138.55417,463.09717,58.196686,463.09717;58.196686,463.09717,61.172882,189.28645");
  img = loadImage("map.png");
} // func 
 
void draw() {
  background(255);
  nodeSelected = null;
  if(toggleMap) image(img, finalPositionX(0), finalPositionY(0), width * scaleRatio, height * scaleRatio);  
  if (toggleNodes) showNodes();
  calculateLinks();
  if (toggleWalls) showWalls();
  showPath();
  if (toggleGraph) showLinks();
  
  
  //stroke(0);
  //line(finalPositionX(500),finalPositionY(300),finalPositionX(800),finalPositionY(300));
  //incidenceMatrix();
  //showMatrix();
  
  
  if (nodeSelected == null){
    //Camera drag
    if (mouseDownRight) {
      if(!shift){
        offsetX += (mouseX-pmouseX) / scaleRatio;
        offsetY += (mouseY-pmouseY) / scaleRatio;
      }
    }
    if(mouseDown && shift){
      if (debouncer == false){
        if (lineX == 0 && lineY == 0) {
          debouncer = true;
          lineX = mouseX;
          lineY = mouseY;
        }else{
          debouncer = true;
          walls.put(numberOfWalls, new Wall(numberOfWalls++,inverseFinalPositionX(lineX), inverseFinalPositionY(lineY), inverseFinalPositionX(mouseX), inverseFinalPositionY(mouseY)));
          lineX = mouseX;
          lineY = mouseY;
          moved = true;
        }
      }
    }
    if (fromKey){
      fromKey = false;
      selectFromNode = null;
    }
    if (toKey){
      toKey = false;
      selectToNode = null;
    }
    //Create node
    if (newNode){
      newNode = false;
      nodes.put(numberOfNodes, new Node(numberOfNodes++,inverseFinalPositionX(mouseX), inverseFinalPositionY(mouseY)));
    }
  }else{
    if(deleteNode){
      deleteNode = false;
      nodes.remove(nodeSelected.id);
    }
    if (mouseDown) {
      // drag and drop
      nodeSelected.px +=(mouseX-pmouseX)/scaleRatio;
      nodeSelected.py +=(mouseY-pmouseY)/scaleRatio;
      moved = true;
    }
    if (fromKey){
      fromKey = false;
      selectFromNode = nodeSelected;
      changed = true;
    }
    if (toKey){
      toKey = false;
      selectToNode = nodeSelected;
      changed = true;
    }
  }
  if(selectFromNode != null && selectToNode != null && changed){
    changed = false;
    dijkstra(selectFromNode, selectToNode);
  }
  if (lineX != 0){
    stroke(0,0,255);
    line(lineX, lineY, mouseX, mouseY);
  }
  deleteNode = false;
  newNode = false;
  fill(255,165,0);
  textAlign(RIGHT, TOP);
  text(links.size(), width - 5, 5);
}
 
// -------------------------------------------------
// Input funcs
 
void mousePressed() {
  if (mouseButton == LEFT)
    mouseDown=true;
  else
    mouseDownRight=true;
} 

void mouseReleased() {
  if (moved) changed = true;
  mouseDown=false;
  mouseDownRight=false;
  debouncer = false;
}
 
void keyPressed() {
  if(key == 'C' || key == 'c'){
    newNode = true;
  }
  if(key == 'D' || key == 'd'){
    deleteNode = true;
  }
  if(key == 'T' || key == 't'){
    toKey = true;
  }
  if(key == 'F' || key == 'f'){
    fromKey = true;
  }
  if(key == 'R' || key == 'r'){
    offsetX = 0;
    offsetY = 0;
    scaleRatio = 1;
  }
  if(key == 'P' || key == 'p'){
    if(shift){
      printWallsData();
    }else{
      printNodesData();
    }
  }
  if(key == 'G' || key == 'g'){
    toggleGraph = !toggleGraph;
  }
  if(key == 'M' || key == 'm'){
    toggleMap = !toggleMap;
  }
  if(key == 'W' || key == 'w'){
    toggleWalls = !toggleWalls;
  }
  if(key == 'N' || key == 'n'){
    toggleNodes = !toggleNodes;
  }
  if(keyCode == SHIFT){
    shift = true;
  }
  
  if(key == 'Z' || key == 'z'){
    if(shift){
      walls.remove(numberOfWalls--);
    }else{
      nodes.remove(numberOfNodes--);
    }
  }
}

void keyReleased(){
  if(keyCode == SHIFT){
    shift = false;
    lineX = 0;
    lineY = 0;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(scaleRatio >= 1 && scaleRatio <= 10){
    float newRatio = e * -0.01 + scaleRatio;
    if(newRatio >= 1 && newRatio <= 10){
      scaleRatio = newRatio;
 
    }
  }
}

// -------------------------------------------------
// other funcs 

void incidenceMatrix(){
  matrix = new float[nodes.size()][nodes.size()];
  int i = 0;
  for(Node currentNode : nodes.values()){
    int j = 0;
    for(Node checkingNode : nodes.values()){
      float dist = Float.MAX_VALUE;
      if (currentNode == checkingNode){
        dist = 0;
      } else {
        for(Link link : links.values()){
            if((link.from == currentNode && link.to == checkingNode) || (link.to == currentNode && link.from == checkingNode)) dist = link.distance;
        }
      }
      matrix[i][j] = dist;
      j++;
    }
    i++;
  }
}

String matrixToString(float[][] matrix){
  String text = "    ";
  for (int i = 0; i < nodes.size(); i++){
    text += (" " + str(i));
  }
  text += "\n";
  for(int i = 0; i < nodes.size(); i++){
    text += str(i)+ " |";
    for(int j = 0; j < nodes.size(); j++){
      
      text += (" " + (matrix[i][j] != Float.MAX_VALUE ? str(matrix[i][j] ): "N/A"));
    }
    text += "\n";
  }
  return text;
}

void showMatrix(){
  String text = matrixToString(matrix);
  fill(255,165,0);
  textAlign(LEFT, TOP);
  text(text, 5, 5);
}

void showLinks(){
  for (Link link : links.values()) {
    link.draw();
  }
}

void showNodes(){
  for (Node node : nodes.values()) {
    node.draw();  // show
    // store number of selected in var "nodeSelected"
    if (node.isSelected) 
      nodeSelected = node;
  }
}

void printNodesData(){
  String data = "";
  for(Node node : nodes.values()){
    data += (node.px + "," + node.py + ";");
  }
  println(data);
}
void printWallsData(){
  String data = "";
  for(Wall wall : walls.values()){
    data += (wall.x1 + "," + wall.y1 + "," + wall.x2 + "," + wall.y2 + ";");
  }
  println(data);
}


void loadNodes(String data){
  String[] textNodes = split(data, ';');
  for (int i = 0; i < textNodes.length; i++){
    String[] nodeData = split(textNodes[i], ',');
    nodes.put(numberOfNodes, new Node(numberOfNodes++,float(nodeData[0]), float(nodeData[1])));
  }
}

void loadWalls(String data){
  String[] textWalls = split(data, ';');
  for (int i = 0; i < textWalls.length; i++){
    String[] nodeData = split(textWalls[i], ',');
    walls.put(numberOfNodes, new Wall(numberOfNodes++, float(nodeData[0]), float(nodeData[1]), float(nodeData[2]), float(nodeData[3])));
  }
}

void calculateLinks(){
  numberOfLinks = 0;
  links.clear();
  for (Node node : nodes.values()) {
    calculateLinksOne(node);
  }
}

void calculateLinksOne(Node fromNode){
  for (Node toNode : nodes.values()){
    if (fromNode != toNode){
      if (sqrt(pow((fromNode.px - toNode.px),2) + pow((fromNode.py - toNode.py),2)) < (searchRadius/conversionRate)){ //if the distance between the nodes is less than 50
        if(!lineLine(fromNode.px, fromNode.py, toNode.px, toNode.py)){
          boolean exists = false;
          for (Link link : links.values()){
            if (link.from == toNode && link.to == fromNode){
              exists = true;
              break;
            }
          }
          if (!exists) links.put(numberOfLinks, new Link(numberOfLinks++,fromNode, toNode));
        }
      }
    }
  }
}

//Check intersections
boolean lineLine(float x1, float y1, float x2, float y2) {
  float x3,  y3,  x4,  y4;
  for (Wall wall : walls.values()) {   
    x3 = wall.x1;
    y3 = wall.y1;
    x4 = wall.x2;
    y4 = wall.y2;
    // calculate the distance to intersection point
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  
    // if uA and uB are between 0-1, lines are colliding
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
      return true;
    }
  }
  return false;
}

float finalPositionX(float x){
  return width/2 + (x - (width/2)) * (scaleRatio) + (offsetX*scaleRatio);
}
float finalPositionY(float y){
  //return (y - ( ((height/2) - y) * (scaleRatio - 1)) + (offsetY * scaleRatio));
  return height/2 + (y - (height/2)) * (scaleRatio) + (offsetY*scaleRatio);
}

void showWalls(){
  for (Wall wall : walls.values()) {
    wall.draw();
  }
}

float inverseFinalPositionX(float x){
  return (width/2) + ((x - (width/2)) / (scaleRatio)) - (offsetX);
}

float inverseFinalPositionY(float y){
  return (height/2) + ((y - (height/2)) / (scaleRatio)) - (offsetY);
}



void dijkstra(Node _fromNode, Node _toNode){
    incidenceMatrix();
    Map<Integer, ArrayList<Integer>> _paths = new HashMap<Integer, ArrayList<Integer>>();
    ArrayList<Integer> initialize = new ArrayList<Integer>();
    initialize.add(_fromNode.id);
    _paths.put(_fromNode.id, initialize);

    float dist[] = new float[nodes.size()]; // The output array. dist[i] will hold 
    // the shortest distance from src to i 

    // sptSet[i] will true if vertex i is included in shortest 
    // path tree or shortest distance from src to i is finalized 
    Boolean sptSet[] = new Boolean[nodes.size()]; 

    // Initialize all distances as INFINITE and stpSet[] as false 
    for (int i = 0; i < nodes.size(); i++) { 
        dist[i] = Float.MAX_VALUE; 
        sptSet[i] = false; 
    } 

    // Distance of source vertex from itself is always 0 
    dist[_fromNode.id] = 0; 
    boolean finished = false;
    // Find shortest path for all vertices
    for (int count = 0; count < nodes.size() - 1; count++) { 
        // Pick the minimum distance vertex from the set of vertices 
        // not yet processed. u is always equal to src in first 
        // iteration. 
        int u = minDistance(dist, sptSet); 

        // Mark the picked vertex as processed 
        sptSet[u] = true; 

        // Update dist value of the adjacent vertices of the 
        // picked vertex. 
        for (int v = 0; v < nodes.size(); v++) {

            // Update dist[v] only if is not in sptSet, there is an 
            // edge from u to v, and total weight of path from src to 
            // v through u is smaller than current value of dist[v] 
            if (!sptSet[v] && matrix[u][v] != 0 && dist[u] != Float.MAX_VALUE && dist[u] + matrix[u][v] < dist[v]){
                dist[v] = dist[u] + matrix[u][v];
                ArrayList<Integer> tempPath = new ArrayList<Integer>();
                copyArrayList(tempPath, _paths.get(u));
                tempPath.add(v);
                if(_paths.containsKey(v)){
                  _paths.replace(v, tempPath);
                }else{
                  _paths.put(v, tempPath);
                }
                if(v == _toNode.id){
                  finished = true;
                  break;
                }
            }
          if(finished)break;
        }
    } 

    // print the constructed distance array
    printPaths(_fromNode.id, _paths);
    setPath(_paths.get(_toNode.id));
    printSolution(dist[_toNode.id]); 
}
void printPaths(int from, Map<Integer, ArrayList<Integer>> paths){
  int i = 0;
  for (ArrayList<Integer> path : paths.values()){
    String text = "";
    for(int j = 0; j < path.size(); j++){
      text += str(path.get(j)) + " ";
    }
    println("From " + from + " to " + i + ": " + text);
    i++;
  }
}
    
int minDistance(float dist[], Boolean sptSet[]){ 
    // Initialize min value 
    float min = Float.MAX_VALUE;
    int min_index = -1; 

    for (int v = 0; v < nodes.size(); v++) 
        if (sptSet[v] == false && dist[v] <= min) { 
            min = dist[v]; 
            min_index = v; 
        } 

    return min_index; 
}
void printSolution(float dist) { 
    println("The distance between points is " + dist + "m"); 
}

void copyArrayList(ArrayList<Integer> to, ArrayList<Integer> from){
  for(int i = 0; i < from.size(); i++){
    to.add(from.get(i));
  }
}

void setPath(ArrayList<Integer> _path){
  path.clear();
  for (int i = 0; i < _path.size() - 1; i++){
    for (Link link : links.values()){
      if ((link.from.id == _path.get(i) && link.to.id == _path.get(i+1)) || (link.to.id == _path.get(i) && link.from.id == _path.get(i+1))){
        path.add(link);
        break;
      }
    }
  }
}

void showPath(){
  for (int i = 0; i < path.size(); i++){
    path.get(i).highlighted = true;
    path.get(i).draw();
  }
}
