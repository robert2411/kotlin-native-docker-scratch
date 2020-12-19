import io.ktor.client.*
import io.ktor.client.engine.*
import io.ktor.client.engine.curl.*
import io.ktor.client.request.*
import kotlinx.coroutines.runBlocking

fun main() = runBlocking{
    println("Hello, Kotlin/Native!")
    Platform.isMemoryLeakCheckerActive = false

    runClient(Curl.create())
}

suspend fun runClient(engine: HttpClientEngine) {
    val client = HttpClient(engine)
    try {
        val response = client.get<String>("https://jsonplaceholder.typicode.com/todos/1")
        print(response)
    } finally {
        // To prevent IllegalStateException https://youtrack.jetbrains.com/issue/KTOR-1071
        client.close()
        engine.close()
    }
}