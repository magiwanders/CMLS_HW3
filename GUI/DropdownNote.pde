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
    
    /* Size of Dropdown because setSize wants int*/
    float wDropdown = width*0.04;
    float hDropdown = height*0.08;
    
    public void init(){
        dropdownNote = cp5.addDropdownList("dropdownNote"+name)
          .setPosition(x, y)
          .setSize((int)wDropdown,(int)hDropdown);
          customize(dropdownNote); // customize the first list
    }
    
    /* Size of Dropdown because setSize wants int*/
    float hItem = height * 0.03;
    float hBar = height * 0.03;
    
    void customize(DropdownList ddl) {
      // a convenience function to customize a DropdownList
      ddl.setBackgroundColor(color(190));
      ddl.setItemHeight((int)hItem);
      ddl.setBarHeight((int)hBar);
      ddl.getCaptionLabel().set(name);
      ddl.setFont(createFont("CopperplateGothic-Light",11));
      
       for (int i=0; i<musicalNotes.length;i++) {
          if (id == 12){
            id = 0;
          }
          ddl.addItem(musicalNotes[id], musicalNotes[id]);
          id++;
        }
      //ddl.scroll(0);
      ddl.setColorBackground(color(60));
      ddl.setColorActive(color(255, 128));
    }
    
public void hide(){
  dropdownNote.hide();
}

public void show(){
  dropdownNote.show();
}

public String getItem(int n){
  return dropdownNote.getItem(n).get("name").toString();
}

public String getName(){
  return dropdownNote.getCaptionLabel().getText();
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
