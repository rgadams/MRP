//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MRPProject
{
    using System;
    using System.Collections.Generic;
    
    public partial class BillOfMaterial
    {
        public int BillOfMaterialsID { get; set; }
        public Nullable<int> ProductAssemblyID { get; set; }
        public int ComponentID { get; set; }
    
        public virtual Part Part { get; set; }
        public virtual Part Part1 { get; set; }
    }
}
