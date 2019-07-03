package vo;

public class Alphabet {

	
	private String letter;
	private int division;
	private int indicator;
	
	public Alphabet() {
	}

	
	public Alphabet(String letter, int division, int indicator) {
		super();
		this.letter = letter;
		this.division = division;
		this.indicator = indicator;
	}

	public String getLetter() {
		return letter;
	}

	public void setLetter(String letter) {
		this.letter = letter;
	}

	public int getDivision() {
		return division;
	}
	public void setDivision(int division) {
		this.division = division;
	}
	public int getIndicator() {
		return indicator;
	}
	public void setIndicator(int indicator) {
		this.indicator = indicator;
	}

	@Override
	public String toString() {
		return "Alphabet [letter=" + letter + ", division=" + division + ", indicator=" + indicator + "]";
	}

	
}//class
