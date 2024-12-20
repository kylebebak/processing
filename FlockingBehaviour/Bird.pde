public class Bird {

	private double px, py; // position
	private double vx, vy; // velocity
	private double fx, fy; // force
	private Color color; // color

	private final double G = 6.67e-11; // attraction constant
	private final double EPS = 3E4; // softening parameter

	/**
	 * create and initialize a new Bird
	 * 
	 * @param px
	 * @param py
	 * @param vx
	 * @param vy
	 * @param color
	 */
	public Bird(double px, double py, double vx, double vy, Color color) {
		this.px = px;
		this.py = py;
		this.vx = vx;
		this.vy = vy;
		this.color = color;
	}

	/**
	 * Copy constructor
	 */
	public Bird(Bird b) {
		px = b.px;
		py = b.py;
		vx = b.vx;
		vy = b.vy;
		color = b.color;
	}

	public boolean in(Quad q) {
		return q.contains(px, py);
	}

	/**
	 * return a new Body that represents the center-of-mass of the the invoking
	 * body and b, using the center-of-mass formula.
	 * <p>
	 * the velocity of this aggregate body is set arbitrarily, because the
	 * position of aggregate bodies is never updated in the simulation. rather,
	 * the BhTree is rebuilt and aggregate bodies are recomputed for each time
	 * quantum dt in the NBody simulation
	 */
	public Bird plus(Bird b) {
		return new Bird((px + b.px) / 2.0, (py + b.py) / 2.0,
				(vx + b.vx) / 2.0, (vy + b.vy) / 2.0, color);
	}

	/**
	 * update the velocity and position of body using leapfrog integration
	 */
	public void update(double dt) {
		vx += dt * fx;
		vy += dt * fy;
		px += dt * vx;
		py += dt * vy;
	}

	/**
	 * return the Euclidean distance between the invoking Body and b
	 */
	public double distanceTo(Bird b) {
		double dx = px - b.px;
		double dy = py - b.py;
		return Math.sqrt(dx * dx + dy * dy);
	}

	/**
	 * reset the force of the invoking Body to 0
	 */
	public void resetForce() {
		fx = 0.0;
		fy = 0.0;
	}

	/**
	 * compute the net force acting between the invoking body a and b, and add
	 * to the net force acting on the invoking Body
	 */
	public void addForce(Bird b) {
		Bird a = this;
		double dx = b.px - a.px;
		double dy = b.py - a.py;
		double dist = Math.sqrt(dx * dx + dy * dy);
		double F = G / (dist * dist + EPS * EPS);
		a.fx += F * dx / dist;
		a.fy += F * dy / dist;
	}

	/**
	 * draw the invoking Bird to standard draw
	 */
	public void draw() {

	}

}
