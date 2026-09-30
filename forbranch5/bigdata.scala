import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global
import scala.util.{Success, Failure}
import scala.concurrent.duration.*
import scala.concurrent.Await

// A mock function simulating a delayed API fetch
def fetchSensorData(sensorId: String): Future[Int] = Future {
  Thread.sleep(1000) // Simulating network lag
  sensorId match
    case "A1" => 42
    case "B2" => 88
    case _    => throw new RuntimeException(s"Sensor $sensorId offline")
}

@main def runConcurrency(): Unit =
  println("⏱️ Launching parallel data fetch...")

  // Fire off async operations in parallel
  val futureA = fetchSensorData("A1")
  val futureB = fetchSensorData("B2")

  // Combine results using a 'for-comprehension' once both succeed
  val combinedResult: Future[String] = 
    for
      valA <- futureA
      valB <- futureB
    yield s"Combined Metric Score: ${valA + valB}"

  // Block the main thread just to wait for the result printout (don't do this in production!)
  val output = Await.result(combinedResult, 3.seconds)
  println(s"✅ Result: $output")
