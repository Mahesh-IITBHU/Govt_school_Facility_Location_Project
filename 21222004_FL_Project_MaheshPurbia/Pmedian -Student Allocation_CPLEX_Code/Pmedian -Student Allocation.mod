/*********************************************
 * OPL 20.1.0.0 Model
 * Author: hp
 * Creation Date: 12-Apr-2022 at 7:43:51 pm
 *********************************************/

// P-Median Probelm
	
// P-Median Probelm
main{
	// Generating & Solving initial model
	thisOplModel.generate(); // Generating the current model instance
		if (cplex.solve())
		{
		var ofile = new IloOplOutputFile("D:/IIT-BHU - Mtech/Semester 2/Facility location models and algorithms/Project/P-Median Cplex Code/Pmedian -Student Allocation/Answer.txt");
  		ofile.writeln(thisOplModel.printSolution());
  		ofile.writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex.getCplexTime());
  		ofile.close();
		var obj = cplex.getObjValue();
		writeln("The Value of the Objective Function Value is (Total Weighted Distance): ", obj);
		writeln("Solving CPU Elapsed Time  in (Seconds): ", cplex.getCplexTime()); 
		thisOplModel.postProcess(); 
		}
	else {
			writeln("No Solution");	
		 } 
	}
	
		
// indicies
{string} Student =...;     //Demandpoints I
{string} School_Loc =...;   //facilities J

// Parameters and Data
int MaxSchools_P =...;  
float Max_dist_K =...;
float Demand[Student]=...;  
float Distance[School_Loc][Student]=...;  

// Decision Variables
dvar boolean Open[School_Loc];                   //yj
dvar boolean Assign[School_Loc][Student];       //xij

// Model 

// objective function

dexpr float tot_dwtdistance = sum(w in School_Loc, c in Student) Distance[w][c]*Demand[c]*Assign[w][c];

// Total demand weighted distance
minimize  tot_dwtdistance;
    
subject to{

  forall ( c in Student) 
    EachStudentDemandMustBeMet:
    	sum( w in School_Loc ) Assign[w][c]==1;	
  
    UseMaximum_P_School:
  	sum(w in School_Loc) Open[w]==MaxSchools_P;
  
    forall (w in School_Loc, c in Student)
    CannotAssignStudent_toSchool_UnlessItIsOpen:
      Assign[w][c] <= Open[w];
      
    forall(w in School_Loc, c in Student)
    MaxDist_CoverbyStudent:
      Distance[w][c]*Assign[w][c] <= Max_dist_K;
            
}