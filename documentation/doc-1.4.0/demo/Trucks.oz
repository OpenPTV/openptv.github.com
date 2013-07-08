%%%
%%% Authors:
%%%   Martin Mueller (mmueller@ps.uni-sb.de)
%%%
%%% Contributors:
%%%   Christian Schulte <schulte@ps.uni-sb.de>
%%%
%%% Copyright:
%%%   Martin Mueller, 1998
%%%   Christian Schulte, 1998
%%%
%%% Last change:
%%%   $Date: 1999-01-21 11:01:50 +0100 (Thu, 21 Jan 1999) $ by $Author: schulte $
%%%   $Revision: 10566 $
%%%
%%% This file is part of Mozart, an implementation
%%% of Oz 3
%%%    http://www.mozart-oz.org
%%%
%%% See the file "LICENSE" or
%%%    http://www.mozart-oz.org/LICENSE.html
%%% for information on usage and redistribution
%%% of this file, and for a DISCLAIMER OF ALL
%%% WARRANTIES.
%%%


functor

require
   DemoUrls(image)

prepare
   ImageNames = [DemoUrls.image#'trucks/truck-right.ppm'
		 DemoUrls.image#'trucks/truck-left.ppm']
   
   Width       = 600
   Height      = 165
   TruckHeight = 60
   Free        = 25

import
   Tk
   TkTools
   Application

define
   Images = {TkTools.images ImageNames}

   class Truck
      prop
	 final
	 
      from
	 Time.repeat Tk.canvasTag
	 
      attr
	 state:off
	 step:1
	 
      meth init(c:Canvas x:X<=0 y:Y<=0)
	 Truck, tkInit(parent:Canvas)
	 
	 {Canvas tk(crea image X Y image:Images.'truck-right' tag:self)}
	 
	 {self setRepAll(delay:  100
			 number: Width div @step
			 action: moveTruck      
			 final:  switch)}
	 
	 {self tkBind(event:'<1>' action:self#toggle)}
	 {self tkBind(event:'<2>' action:self#change(~1))}
	 {self tkBind(event:'<3>' action:self#change(1))}
      end
      
      meth moveTruck
	 Truck, tk(move @step 0)
      end
      
      meth switch 
	 step <- ~1 * @step
	 if @step>0
	 then {self tk(itemconf image:Images.'truck-right')}
	 else {self tk(itemconf image:Images.'truck-left')} 
	 end
	 {self go}
      end
      
      meth toggle
	 try 
	    case @state
	    of off then state<-on  {self go}
	    [] on  then state<-off {self stop}
	    end
	 catch system(...) then skip 
	 end
      end
      
      meth change(S)
	 N = {self getRep(delay:$)}
      in
	 {self setRepDelay({Max 2 N+S*(N div 2)})}
      end
      
      meth close
	 Time.repeat,  stop
	 Tk.canvasTag, tkClose
      end
   end
   
   T = {New Tk.toplevel tkInit(title:  'Truckrace'
			       delete: Application.exit # 0)}
   
   C = {New Tk.canvas tkInit(parent: T
			     bg:     white
			     width:  Width
			     height: Height)}
   
   {Tk.send pack(C fill:both)}
   
   thread {New Truck init(c:C y:Free)  _} end
   thread {New Truck init(c:C y:Free+TruckHeight)  _} end
   thread {New Truck init(c:C y:Free+TruckHeight*2) _} end
   
end
