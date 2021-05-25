import controlP5.*;
public class DropdownNote{
    
    int id;
    float x, y;
    String name;
    String[] musicalNotes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
    boolean isActive;
    ControlP5 cp5Harmonic;
    Toggle toggleHarmonic;
    DropdownList dropdownNote;
  
    public DropdownNote (int idDropdownNote, String idName, ControlP5 cp5, float xPosition, float yPosition){
      id = idDropdownNote;
      name = idName;
      isActive = false;
      cp5Harmonic = cp5;
      x = xPosition;
      y = yPosition;   
    }
    
    public void init(){
        dropdownNote = cp5.addDropdownList("dropdownNote"+name)
          .setPosition(x, y)
          .setSize(50,50);
          customize(dropdownNote); // customize the first list
    }
    
    void customize(DropdownList ddl) {
      // a convenience function to customize a DropdownList
      ddl.setBackgroundColor(color(190));
      ddl.setItemHeight(20);
      ddl.setBarHeight(15);
      ddl.getCaptionLabel().set(name);
       for (int i=0; i<musicalNotes.length;i++) {
          if (id == 12){
            id = 0;
          }
          ddl.addItem(musicalNotes[id], musicalNotes[id]);
          id++;
        }
      ddl.getItem(0);
      //ddl.scroll(0);
      ddl.setColorBackground(color(60));
      ddl.setColorActive(color(255, 128));
    }
    

    
    
     /*public void active(){
      if(mousePressed){
        isActive = !isActive;
        println(name + " è " + isActive);
      }
    }

    public void init(){
      toggleHarmonic = cp5Harmonic.addToggle(name)
        .setLabel(note)
        .setPosition(x,y)
        .setSize(40,40)
        .setFont(createFont("Consolas",12));
        
      toggleHarmonic.isMousePressed();
    }*/
    
   
   
    
   
}
